// supabase/functions/generate-itinerary-pdf/data.fetcher.ts
export async function fetchItineraryData(itineraryId, accountId, supabaseClient) {
  console.log(`Fetching data for itinerary ID: ${itineraryId}, account ID: ${accountId || 'not provided'}`);
  try {
    // 1. Get itinerary details
    console.log('Fetching itinerary details...');
    const { data: itineraryData, error: itineraryError } = await supabaseClient.from('itineraries').select('*').eq('id', itineraryId).single();
    if (itineraryError) {
      console.error('Error fetching itinerary:', itineraryError);
      throw itineraryError;
    }
    if (!itineraryData) {
      console.warn(`Itinerary with ID ${itineraryId} not found`);
      return null;
    }
    // Handle currency information in a more resilient way
    console.log('Processing currency information...');
    let currencyData = {
      id: itineraryData.currency_type || 'USD',
      code: itineraryData.currency_type || 'USD',
      symbol: '$',
      name: 'US Dollar'
    };
    // Try to get currency details from itinerary.currency if available
    if (itineraryData.currency && typeof itineraryData.currency === 'object') {
      currencyData = {
        ...currencyData,
        ...itineraryData.currency
      };
    }
    // 2. Get contact (client) details
    console.log('Fetching contact details...');
    let contactData = null;
    if (itineraryData.id_contact) {
      const { data: contact, error: contactError } = await supabaseClient.from('contacts').select('*').eq('id', itineraryData.id_contact).single();
      if (contactError) {
        console.error('Error fetching contact:', contactError);
      // Don't throw, use default contact with itinerary contact name if available
      } else {
        contactData = contact;
        // Si el contacto tiene user_image, asegúrate de que sea una URL válida
        if (contactData.user_image && !contactData.user_image.startsWith('http')) {
          try {
            // Intenta obtener URL pública para la imagen del usuario desde Storage
            const { data: userImageUrl } = supabaseClient.storage.from('images').getPublicUrl(contactData.user_image);
            if (userImageUrl) {
              contactData.user_image = userImageUrl.publicUrl;
            }
          } catch (e) {
            console.warn('Error obteniendo URL pública para imagen de usuario:', e);
          }
        }
      }
    }
    // If contact not found, try to fetch contact name from itineraries_with_contact_names function
    if (!contactData) {
      console.warn('Contact not found via direct lookup, trying to get contact name from itinerary function');
      try {
        const { data: itineraryWithContact } = await supabaseClient.rpc('function_get_itineraries_with_id', {
          itinerary_id: itineraryId
        });
        if (itineraryWithContact && itineraryWithContact.length > 0) {
          // Use the contact name from the function result
          contactData = {
            id: itineraryData.id_contact || '00000000-0000-0000-0000-000000000000',
            name: itineraryWithContact[0].contact_name || 'Cliente',
            lastname: '',
            email: '',
            phone: '',
            user_image: ''
          };
          console.log('Retrieved contact name from function:', contactData.name);
        } else {
          // Default contact if nothing found
          contactData = {
            id: itineraryData.id_contact || '00000000-0000-0000-0000-000000000000',
            name: 'Cliente',
            lastname: '',
            email: '',
            phone: '',
            user_image: ''
          };
        }
      } catch (e) {
        console.warn('Error fetching contact name from function:', e);
        // Default contact as fallback
        contactData = {
          id: itineraryData.id_contact || '00000000-0000-0000-0000-000000000000',
          name: 'Cliente',
          lastname: '',
          email: '',
          phone: '',
          user_image: ''
        };
      }
    }
    // 3. Get account details
    console.log('Fetching account details...');
    let accountData = null;
    let useAccountId = null;
    // Only try to convert accountId to UUID if it's a string with content
    if (accountId && typeof accountId === 'string' && accountId.trim() !== '') {
      useAccountId = accountId;
    }
    // Fallback to itinerary's account_id if provided accountId is invalid
    if (!useAccountId && itineraryData.account_id) {
      useAccountId = itineraryData.account_id;
    }
    if (useAccountId) {
      const { data: account, error: accountError } = await supabaseClient.from('accounts').select('*').eq('id', useAccountId).single();
      if (accountError) {
        console.error('Error fetching account:', accountError);
      // Don't throw, we'll use default account
      } else {
        accountData = account;
      }
    }
    // Fallback to default account if needed
    if (!accountData) {
      console.warn('No account found, trying to find default account');
      try {
        const { data: defaultAccounts } = await supabaseClient.from('accounts').select('*').eq('is_default', true).limit(1);
        if (defaultAccounts && defaultAccounts.length > 0) {
          accountData = defaultAccounts[0];
        }
      } catch (e) {
        console.warn('Error fetching default account:', e);
      }
    }
    // Use basic account if still not found
    if (!accountData) {
      accountData = {
        id: useAccountId || '00000000-0000-0000-0000-000000000000',
        name: 'Company Name',
        logo_account: '',
        type_id: 'NIT',
        number_id: '000000000',
        phone: '',
        mail: ''
      };
    }
    // 4. Get agent details if available
    console.log('Fetching agent details...');
    let agentData = null;
    if (itineraryData.id_created_by) {
      try {
        // Intentar obtener datos del agente a través del usuario que creó el itinerario
        // Este usuario debería tener un registro asociado en la tabla contacts
        const { data: agentContact, error: agentContactError } = await supabaseClient.from('contacts').select('id, name, lastname, email, user_image').eq('user_id', itineraryData.id_created_by).single();
        if (!agentContactError && agentContact) {
          agentData = {
            name: agentContact.name || '',
            lastname: agentContact.lastname || '',
            email: agentContact.email || '',
            image: agentContact.user_image || ''
          };
          console.log(`Found agent data for user_id: ${itineraryData.id_created_by}`, agentData);
        } else {
          // Si no se encuentra por user_id, intentar por agent_id (que podría ser el ID de un contacto)
          if (itineraryData.agent_id) {
            const { data: directAgent, error: directAgentError } = await supabaseClient.from('contacts').select('name, lastname, email, user_image').eq('id', itineraryData.agent_id).single();
            if (!directAgentError && directAgent) {
              agentData = {
                name: directAgent.name || '',
                lastname: directAgent.lastname || '',
                email: directAgent.email || '',
                image: directAgent.user_image || ''
              };
              console.log(`Found agent data for agent_id: ${itineraryData.agent_id}`, agentData);
            }
          }
        }
        // Si aún no tenemos datos del agente, intentar buscar en la tabla de usuarios directamente
        if (!agentData && itineraryData.id_created_by) {
          const { data: userData, error: userError } = await supabaseClient.from('users').select('email').eq('id', itineraryData.id_created_by).single();
          if (!userError && userData) {
            // Si encontramos el email, buscar si hay algún contacto con ese email
            const { data: emailContact, error: emailContactError } = await supabaseClient.from('contacts').select('name, lastname, email, user_image').eq('email', userData.email).single();
            if (!emailContactError && emailContact) {
              agentData = {
                name: emailContact.name || '',
                lastname: emailContact.lastname || '',
                email: emailContact.email || '',
                image: emailContact.user_image || ''
              };
              console.log(`Found agent data by email: ${userData.email}`, agentData);
            }
          }
        }
        // Asegurarse de que la imagen del agente sea una URL completa
        if (agentData && agentData.image) {
          // Si comienza con 'http', asumimos que ya es una URL completa
          if (!agentData.image.startsWith('http') && agentData.image !== '') {
            try {
              // Si es una ruta de storage, obtenemos la URL pública
              const { data: agentImageUrl } = supabaseClient.storage.from('images').getPublicUrl(agentData.image);
              if (agentImageUrl && agentImageUrl.publicUrl) {
                agentData.image = agentImageUrl.publicUrl;
                console.log('Converted agent image to public URL:', agentData.image);
              }
            } catch (e) {
              console.warn('Error obteniendo URL pública para imagen de agente:', e);
            }
          }
        }
      } catch (e) {
        console.warn('Error fetching agent details:', e);
      }
    }
    // Use default agent if not found
    if (!agentData) {
      console.log('No agent data found, using default agent data');
      agentData = {
        name: itineraryData.agent || 'Travel',
        lastname: 'Agent',
        email: 'agent@example.com',
        image: ''
      };
    } else {
      console.log('Using found agent data:', agentData);
    }
    // 5. Get itinerary items
    console.log('Fetching itinerary items...');
    const { data: itemsData, error: itemsError } = await supabaseClient.from('itinerary_items').select('*').eq('id_itinerary', itineraryId).order('date', {
      ascending: true
    });
    if (itemsError) {
      console.error('Error fetching itinerary items:', itemsError);
      throw itemsError;
    }
    // Process items to match expected format
    const processedItems = await Promise.all((itemsData || []).map(async (item)=>{
      let productDetails = null;
      let productDescription = item.description || '';
      let mainImage = item.main_image || '';
      let inclutions = item.inclutions || '';
      let exclutions = item.exclutions || '';
      let recomendations = item.recomendations || '';
      // Obtener detalles adicionales del producto según su tipo
      if (item.id_product && item.product_type) {
        const productType = item.product_type.toLowerCase();
        let table = '';
        if (productType.includes('hotel')) {
          table = 'hotels';
        } else if (productType.includes('servicio')) {
          table = 'activities'; // Fetch details from 'activities' table
        } else if (productType.includes('vuelo') || productType.includes('flight')) {
          table = 'flights';
        } else if (productType.includes('trans')) {
          table = 'transfers';
        }
        if (table) {
          try {
            const { data: product, error: productError } = await supabaseClient.from(table).select('description, description_short, main_image, inclutions, exclutions, recomendations').eq('id', item.id_product).single();
            if (!productError && product) {
              productDetails = product;
              // Use product details if item doesn't have them
              if (!productDescription && (product.description || product.description_short)) {
                productDescription = product.description || product.description_short;
              }
              if (!mainImage && product.main_image) {
                mainImage = product.main_image;
              }
              if (!inclutions && product.inclutions) {
                inclutions = product.inclutions;
              }
              if (!exclutions && product.exclutions) {
                exclutions = product.exclutions;
              }
              if (!recomendations && product.recomendations) {
                recomendations = product.recomendations;
              }
            }
          } catch (e) {
            console.warn(`Error fetching product details for ${item.product_type} ID ${item.id_product}:`, e);
          }
        }
      }
      // Fetch schedule items separately
      let scheduleItems = [];
      if (item.id) {
        try {
          const { data: scheduleData } = await supabaseClient.from('schedule_items').select('*').eq('itinerary_item_id', item.id).order('position', {
            ascending: true
          });
          if (scheduleData && scheduleData.length > 0) {
            scheduleItems = scheduleData;
          }
        } catch (e) {
          console.warn(`Error fetching schedule for item ${item.id}:`, e);
        }
      }
      // Process images
      let images = [];
      // Para hoteles y servicios (actividades), obtener imágenes directamente relacionadas con el ID del producto
      if ((item.product_type === 'Hoteles' || item.product_type === 'Servicios') && item.id_product) {
        try {
          // Determinar el tipo de entidad para el log
          const entityType = item.product_type === 'Hoteles' ? 'hotel' : 'actividad';
          console.log(`Buscando imágenes para ${entityType} con ID: ${item.id_product}`);
          const { data: entityImageData, error: entityImagesError } = await supabaseClient.from('images').select('url').eq('entity_id', item.id_product).limit(3); // Reducido a 3 imágenes para mejor visualización
          if (!entityImagesError && entityImageData && entityImageData.length > 0) {
            console.log(`Encontradas ${entityImageData.length} imágenes para ${entityType} con ID ${item.id_product}`);
            images = entityImageData.map((img)=>img.url);
            // Si hay una imagen principal y no está en las imágenes obtenidas, la agregamos al principio
            if (mainImage && !images.includes(mainImage)) {
              images.unshift(mainImage);
            }
          } else {
            console.log(`No se encontraron imágenes específicas para ${entityType} con ID ${item.id_product}`);
            // Si no hay imágenes específicas y tenemos una imagen principal, la usamos
            if (mainImage) {
              images.push(mainImage);
            }
          }
        } catch (e) {
          console.warn(`Error al buscar imágenes para ${item.product_type.toLowerCase()} ${item.id_product}:`, e);
          if (mainImage) images.push(mainImage);
        }
      } else {
        // Para otros tipos de productos, conservamos la lógica original
        if (mainImage) {
          // Si hay una imagen principal, asegúrate de incluirla primero
          images.push(mainImage);
        }
        // Obtener las imágenes adicionales del item del itinerario
        if (item.id) {
          try {
            const { data: imageData } = await supabaseClient.from('images').select('url').eq('entity_id', item.id).limit(3);
            if (imageData && imageData.length > 0) {
              const additionalImages = imageData.map((img)=>img.url).filter((url)=>url !== mainImage); // Evitar duplicar la imagen principal
              images = [
                ...images,
                ...additionalImages
              ];
            }
          } catch (e) {
            console.warn(`Error fetching images for item ${item.id}:`, e);
          }
        }
        // Si aún no hay imágenes y tenemos un id_product, intenta obtener imágenes del producto
        if (images.length === 0 && item.id_product) {
          try {
            const { data: productImageData } = await supabaseClient.from('images').select('url').eq('entity_id', item.id_product).limit(3);
            if (productImageData && productImageData.length > 0) {
              images = productImageData.map((img)=>img.url);
            }
          } catch (e) {
            console.warn(`Error fetching product images for product ID ${item.id_product}:`, e);
          }
        }
        // Si hay una imagen de aerolínea para vuelos, intenta obtenerla
        if (item.product_type === 'Vuelos' && item.airline) {
          try {
            const { data: airlineData, error: airlineError } = await supabaseClient.from('airlines').select('logo_symbol_url').eq('id', item.airline).single();
            if (!airlineError && airlineData && airlineData.logo_symbol_url) {
              mainImage = airlineData.logo_symbol_url;
              // Si no hay otras imágenes, usar la imagen de la aerolínea
              if (images.length === 0) {
                images.push(mainImage);
              }
            }
          } catch (e) {
            console.warn(`Error fetching airline logo for airline ID ${item.airline}:`, e);
          }
        }
      }
      // Limitar la cantidad de imágenes a un máximo de 3
      if (images.length > 3) {
        images = images.slice(0, 3);
      }
      console.log(`Imágenes para ítem ${item.id} (${item.product_name}):`, JSON.stringify(images));
      return {
        ...item,
        description: productDescription,
        images: images,
        main_image: mainImage,
        inclutions: inclutions,
        exclutions: exclutions,
        recomendations: recomendations,
        schedule: scheduleItems || []
      };
    }));
    // Convert account logo to base64 if available
    let logoBase64 = null;
    if (accountData && accountData.logo_account) {
      try {
        const response = await fetch(accountData.logo_account);
        if (response.ok) {
          const contentType = response.headers.get('content-type') || 'image/png';
          const arrayBuffer = await response.arrayBuffer();
          const base64 = btoa(String.fromCharCode(...new Uint8Array(arrayBuffer)));
          logoBase64 = `data:${contentType};base64,${base64}`;
        }
      } catch (e) {
        console.warn(`Error converting account logo to base64:`, e);
      }
    }
    // Convert agent image to base64 if available
    if (agentData && agentData.image) {
      try {
        const response = await fetch(agentData.image);
        if (response.ok) {
          const contentType = response.headers.get('content-type') || 'image/jpeg';
          const arrayBuffer = await response.arrayBuffer();
          const base64 = btoa(String.fromCharCode(...new Uint8Array(arrayBuffer)));
          agentData.image = `data:${contentType};base64,${base64}`;
        }
      } catch (e) {
        console.warn(`Error converting agent image to base64:`, e);
      }
    }
    // Construct and return the data in the expected format
    const result = {
      contact: contactData,
      agent: agentData,
      itinerary: {
        ...itineraryData,
        currency: currencyData,
        moneda: currencyData.code || 'USD'
      },
      items: processedItems,
      account: {
        ...accountData || {},
        logo_image_base64: logoBase64
      }
    };
    console.log(`Successfully fetched data for itinerary: ${result.itinerary?.name || 'Unknown'}`);
    return result;
  } catch (error) {
    console.error(`Error fetching itinerary data:`, error);
    throw error;
  }
}
export async function fetchImagesForEntity(entityId, supabaseClient, limit = 3) {
  if (!entityId) {
    return [];
  }
  try {
    console.log(`Fetching images for entity ID: ${entityId}`);
    // Fallback to direct query
    console.log(`Using direct query for images of entity ID: ${entityId}`);
    const { data, error } = await supabaseClient.from('images').select('url').eq('entity_id', entityId).limit(limit);
    if (error) {
      console.error(`Error fetching images:`, error);
      return [];
    }
    if (!data || data.length === 0) {
      return [];
    }
    return data.map((item)=>item.url);
  } catch (error) {
    console.error(`Error in fetchImagesForEntity:`, error);
    return [];
  }
}
