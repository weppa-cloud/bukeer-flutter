import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:bukeer/design_system/tokens/index.dart';

class ImageSelectionSection extends StatelessWidget {
  final List<dynamic> images;

  const ImageSelectionSection({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 1.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(1.0, 0.0),
                child: Builder(
                  builder: (context) {
                    final imagesItem = images.toList();

                    return MasonryGridView.builder(
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 0.0,
                      itemCount: imagesItem.length,
                      itemBuilder: (context, imagesItemIndex) {
                        final imagesItemItem = imagesItem[imagesItemIndex];
                        return _ImageItem(
                          imageItem: imagesItemItem,
                          index: imagesItemIndex,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  final dynamic imageItem;
  final int index;

  const _ImageItem({
    required this.imageItem,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = valueOrDefault<String>(
      getJsonField(imageItem, r'''$.url''')?.toString(),
      'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
    );

    final selectedImageUrl = context.watch<UiStateService>().selectedImageUrl;
    final isSelected = imageUrl == selectedImageUrl;

    return Align(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Stack(
        alignment: const AlignmentDirectional(1.0, -1.0),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: Hero(
              tag: imageUrl + '$index',
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(1.0, -1.0),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (!isSelected) {
                    context.read<UiStateService>().selectedImageUrl = imageUrl;
                  }
                },
                child: Icon(
                  isSelected ? Icons.star_outlined : Icons.star_outline,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
