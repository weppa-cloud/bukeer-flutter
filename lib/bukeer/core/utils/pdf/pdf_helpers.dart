/// PDF generation helper utilities

/// Calculates page breaks for PDF content
///
/// [items] - List of items to paginate
/// [itemsPerPage] - Number of items per page
///
/// Returns list of page groups
List<List<T>> paginateForPDF<T>(List<T> items, int itemsPerPage) {
  final pages = <List<T>>[];

  for (int i = 0; i < items.length; i += itemsPerPage) {
    final end =
        (i + itemsPerPage < items.length) ? i + itemsPerPage : items.length;
    pages.add(items.sublist(i, end));
  }

  return pages;
}

/// Calculates total pages needed
///
/// [totalItems] - Total number of items
/// [itemsPerPage] - Items per page
///
/// Returns total number of pages
int calculateTotalPages(int totalItems, int itemsPerPage) {
  return (totalItems / itemsPerPage).ceil();
}

/// Generates page numbering text
///
/// [currentPage] - Current page number
/// [totalPages] - Total number of pages
/// [locale] - Locale for text (default: 'es')
///
/// Returns page numbering text
String generatePageNumbering(int currentPage, int totalPages,
    {String locale = 'es'}) {
  if (locale == 'es') {
    return 'Página $currentPage de $totalPages';
  } else {
    return 'Page $currentPage of $totalPages';
  }
}

/// Calculates content height for PDF layout
///
/// [lines] - Number of text lines
/// [lineHeight] - Height per line in points
/// [additionalSpace] - Extra space to add
///
/// Returns total height needed
double calculateContentHeight(int lines, double lineHeight,
    {double additionalSpace = 0}) {
  return (lines * lineHeight) + additionalSpace;
}

/// Wraps text for PDF with maximum line width
///
/// [text] - Text to wrap
/// [maxCharsPerLine] - Maximum characters per line
///
/// Returns list of wrapped lines
List<String> wrapTextForPDF(String text, int maxCharsPerLine) {
  if (text.length <= maxCharsPerLine) {
    return [text];
  }

  final lines = <String>[];
  final words = text.split(' ');
  String currentLine = '';

  for (final word in words) {
    if (currentLine.isEmpty) {
      currentLine = word;
    } else if ((currentLine.length + word.length + 1) <= maxCharsPerLine) {
      currentLine += ' $word';
    } else {
      lines.add(currentLine);
      currentLine = word;
    }
  }

  if (currentLine.isNotEmpty) {
    lines.add(currentLine);
  }

  return lines;
}

/// Sanitizes text for PDF generation
///
/// Removes or replaces characters that might cause issues in PDF
///
/// [text] - Text to sanitize
///
/// Returns sanitized text
String sanitizeForPDF(String text) {
  return text
      .replaceAll('\u0000', '') // Remove null characters
      .replaceAll('\r\n', '\n') // Normalize line endings
      .replaceAll('\r', '\n')
      .trim();
}

/// Creates a summary table data structure
///
/// [items] - List of items with amount
/// [labelKey] - Key for label in item map
/// [amountKey] - Key for amount in item map
///
/// Returns formatted table data
List<Map<String, dynamic>> createSummaryTable(
  List<Map<String, dynamic>> items,
  String labelKey,
  String amountKey,
) {
  final tableData = <Map<String, dynamic>>[];
  double subtotal = 0;

  for (final item in items) {
    final amount = (item[amountKey] ?? 0).toDouble();
    subtotal += amount;

    tableData.add({
      'label': item[labelKey] ?? '',
      'amount': amount,
    });
  }

  tableData.add({
    'label': 'Subtotal',
    'amount': subtotal,
    'isTotal': true,
  });

  return tableData;
}

/// Generates barcode data for PDF
///
/// [code] - Code to convert to barcode
/// [type] - Type of barcode (e.g., 'CODE128', 'QR')
///
/// Returns barcode data string
String generateBarcodeData(String code, {String type = 'CODE128'}) {
  // This is a placeholder - actual implementation would use a barcode library
  // For now, return the code with type prefix
  return '$type:$code';
}

/// Calculates optimal image dimensions for PDF
///
/// [originalWidth] - Original image width
/// [originalHeight] - Original image height
/// [maxWidth] - Maximum allowed width
/// [maxHeight] - Maximum allowed height
///
/// Returns Map with 'width' and 'height' keys
Map<String, double> calculateImageDimensions(
  double originalWidth,
  double originalHeight,
  double maxWidth,
  double maxHeight,
) {
  double width = originalWidth;
  double height = originalHeight;

  // Calculate scaling factors
  final widthScale = maxWidth / originalWidth;
  final heightScale = maxHeight / originalHeight;

  // Use the smaller scale to fit within bounds
  final scale = widthScale < heightScale ? widthScale : heightScale;

  if (scale < 1) {
    width = originalWidth * scale;
    height = originalHeight * scale;
  }

  return {
    'width': width,
    'height': height,
  };
}
