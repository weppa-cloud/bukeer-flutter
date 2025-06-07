import 'package:flutter/material.dart';
import '../index.dart';

/// Examples demonstrating the extended design tokens in action
/// Shows practical usage of animations, iconography, shadows, and themes
class ExtendedTokensExamples extends StatefulWidget {
  const ExtendedTokensExamples({super.key});

  @override
  State<ExtendedTokensExamples> createState() => _ExtendedTokensExamplesState();
}

class _ExtendedTokensExamplesState extends State<ExtendedTokensExamples>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: BukeerAnimations.medium,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: BukeerAnimations.easeSmooth,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extended Design Tokens'),
        backgroundColor: BukeerColors.surfacePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: BukeerSpacing.screenEdges,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🎬 Animation Examples'),
            const SizedBox(height: BukeerSpacing.m),
            _buildAnimationExamples(),
            
            const SizedBox(height: BukeerSpacing.xl),
            _buildSectionTitle('🎨 Icon Examples'),
            const SizedBox(height: BukeerSpacing.m),
            _buildIconExamples(),
            
            const SizedBox(height: BukeerSpacing.xl),
            _buildSectionTitle('✨ Shadow Examples'),
            const SizedBox(height: BukeerSpacing.m),
            _buildShadowExamples(),
            
            const SizedBox(height: BukeerSpacing.xl),
            _buildSectionTitle('🌙 Theme Examples'),
            const SizedBox(height: BukeerSpacing.m),
            _buildThemeExamples(),
            
            const SizedBox(height: BukeerSpacing.xl),
            _buildSectionTitle('🎯 Complex Interaction Example'),
            const SizedBox(height: BukeerSpacing.m),
            _buildComplexExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Outfit',
        color: BukeerColors.textPrimary,
      ),
    );
  }

  Widget _buildAnimationExamples() {
    return Column(
      children: [
        // Button with scale animation
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_isAnimating) return;
                  setState(() => _isAnimating = true);
                  _animationController.forward().then((_) {
                    _animationController.reverse().then((_) {
                      setState(() => _isAnimating = false);
                    });
                  });
                },
                icon: BukeerIconography.icon(
                  BukeerIconography.play,
                  size: IconSize.sm,
                ),
                label: const Text('Animate Me'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BukeerColors.primary,
                  foregroundColor: BukeerColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: BukeerSpacing.l,
                    vertical: BukeerSpacing.m,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: BukeerSpacing.m),
        
        // Fade transition example
        AnimatedContainer(
          duration: BukeerAnimations.slow,
          curve: BukeerAnimations.easeSmooth,
          height: _isAnimating ? 100.0 : 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _isAnimating ? BukeerColors.secondary : BukeerColors.primary,
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            boxShadow: _isAnimating ? BukeerShadows.medium : BukeerShadows.small,
          ),
          child: Center(
            child: Text(
              _isAnimating ? 'Animating!' : 'Ready to animate',
              style: const TextStyle(
                color: BukeerColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconExamples() {
    return Wrap(
      spacing: BukeerSpacing.m,
      runSpacing: BukeerSpacing.m,
      children: [
        // Travel icons
        _buildIconCard(
          BukeerIconography.hotel,
          'Hotel',
          IconSize.lg,
          BukeerColors.primary,
        ),
        _buildIconCard(
          BukeerIconography.flight,
          'Flight',
          IconSize.lg,
          BukeerColors.secondary,
        ),
        _buildIconCard(
          BukeerIconography.activity,
          'Activity',
          IconSize.lg,
          BukeerColors.success,
        ),
        _buildIconCard(
          BukeerIconography.transfer,
          'Transfer',
          IconSize.lg,
          BukeerColors.warning,
        ),
        
        // Status icons
        _buildStatusIconCard(IconStatus.success, 'Success'),
        _buildStatusIconCard(IconStatus.warning, 'Warning'),
        _buildStatusIconCard(IconStatus.error, 'Error'),
        _buildStatusIconCard(IconStatus.info, 'Info'),
        
        // Rotating loading icon
        Container(
          padding: BukeerSpacing.cardInternal,
          decoration: BoxDecoration(
            color: BukeerColors.surfacePrimary,
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            boxShadow: BukeerShadows.card,
          ),
          child: Column(
            children: [
              BukeerIconography.rotatingIcon(
                BukeerIconography.loading,
                size: IconSize.lg,
                color: BukeerColors.primary,
              ),
              const SizedBox(height: BukeerSpacing.xs),
              const Text(
                'Loading',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconCard(IconData iconData, String label, IconSize size, Color color) {
    return Container(
      padding: BukeerSpacing.cardInternal,
      decoration: BoxDecoration(
        color: BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        boxShadow: BukeerShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BukeerIconography.icon(
            iconData,
            size: size,
            color: color,
          ),
          const SizedBox(height: BukeerSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIconCard(IconStatus status, String label) {
    return Container(
      padding: BukeerSpacing.cardInternal,
      decoration: BoxDecoration(
        color: BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        boxShadow: BukeerShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BukeerIconography.statusIcon(status, size: IconSize.lg),
          const SizedBox(height: BukeerSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowExamples() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildShadowCard('Subtle', BukeerShadows.subtle),
            ),
            const SizedBox(width: BukeerSpacing.m),
            Expanded(
              child: _buildShadowCard('Small', BukeerShadows.small),
            ),
            const SizedBox(width: BukeerSpacing.m),
            Expanded(
              child: _buildShadowCard('Medium', BukeerShadows.medium),
            ),
          ],
        ),
        const SizedBox(height: BukeerSpacing.m),
        Row(
          children: [
            Expanded(
              child: _buildShadowCard('Large', BukeerShadows.large),
            ),
            const SizedBox(width: BukeerSpacing.m),
            Expanded(
              child: _buildShadowCard('Extra Large', BukeerShadows.extraLarge),
            ),
          ],
        ),
        const SizedBox(height: BukeerSpacing.m),
        
        // Colored shadows
        Row(
          children: [
            Expanded(
              child: Container(
                height: 80,
                margin: const EdgeInsets.all(BukeerSpacing.s),
                decoration: BoxDecoration(
                  color: BukeerColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  boxShadow: BukeerShadows.createPrimaryTinted(),
                ),
                child: const Center(
                  child: Text(
                    'Primary Shadow',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 80,
                margin: const EdgeInsets.all(BukeerSpacing.s),
                decoration: BoxDecoration(
                  color: BukeerColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  boxShadow: BukeerShadows.createSecondaryTinted(),
                ),
                child: const Center(
                  child: Text(
                    'Secondary Shadow',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShadowCard(String title, List<BoxShadow> shadow) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(BukeerSpacing.s),
      decoration: BoxDecoration(
        color: BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        boxShadow: shadow,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeExamples() {
    return Container(
      padding: BukeerSpacing.cardInternal,
      decoration: BoxDecoration(
        color: BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        boxShadow: BukeerShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme Integration Example',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: BukeerSpacing.s),
          Text(
            'This card uses theme data with extended tokens.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: BukeerSpacing.m),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Primary'),
                ),
              ),
              const SizedBox(width: BukeerSpacing.s),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
              ),
              const SizedBox(width: BukeerSpacing.s),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: BukeerSpacing.m),
          
          // Form example
          TextField(
            decoration: InputDecoration(
              labelText: 'Theme-aware TextField',
              prefixIcon: BukeerIconography.icon(
                BukeerIconography.email,
                size: IconSize.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplexExample() {
    return AnimatedContainer(
      duration: BukeerAnimations.medium,
      curve: BukeerAnimations.easeSmooth,
      padding: BukeerSpacing.cardInternal,
      decoration: BoxDecoration(
        color: BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        boxShadow: _isAnimating ? BukeerShadows.large : BukeerShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              BukeerIconography.icon(
                BukeerIconography.itinerary,
                size: IconSize.lg,
                color: BukeerColors.primary,
              ),
              const SizedBox(width: BukeerSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Complex Interaction Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: BukeerColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: BukeerSpacing.xs),
                    Text(
                      'Combines animations, icons, shadows, and themes',
                      style: TextStyle(
                        fontSize: 14,
                        color: BukeerColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              BukeerIconography.statusIcon(
                _isAnimating ? IconStatus.loading : IconStatus.success,
                size: IconSize.md,
              ),
            ],
          ),
          
          const SizedBox(height: BukeerSpacing.m),
          
          AnimatedContainer(
            duration: BukeerAnimations.fast,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: BukeerColors.neutralLight,
            ),
            child: FractionallySizedBox(
              widthFactor: _isAnimating ? 1.0 : 0.3,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: BukeerColors.primary,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: BukeerSpacing.m),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_isAnimating) return;
                setState(() => _isAnimating = true);
                _animationController.forward().then((_) {
                  Future.delayed(BukeerAnimations.slow).then((_) {
                    _animationController.reverse().then((_) {
                      setState(() => _isAnimating = false);
                    });
                  });
                });
              },
              icon: BukeerIconography.icon(
                _isAnimating ? BukeerIconography.loading : BukeerIconography.play,
                size: IconSize.sm,
              ),
              label: Text(_isAnimating ? 'Running...' : 'Start Demo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: BukeerColors.primary,
                foregroundColor: BukeerColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: BukeerSpacing.m,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Example showing how to create custom page transitions
class CustomPageTransitionExample extends StatelessWidget {
  const CustomPageTransitionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Transition Examples'),
      ),
      body: Padding(
        padding: BukeerSpacing.screenEdges,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    BukeerAnimations.createPageRoute(
                      page: const _DestinationPage('Fade Transition'),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: const Text('Fade Transition'),
              ),
            ),
            
            const SizedBox(height: BukeerSpacing.m),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    BukeerAnimations.createPageRoute(
                      page: const _DestinationPage('Slide Transition'),
                      type: PageTransitionType.slide,
                    ),
                  );
                },
                child: const Text('Slide Transition'),
              ),
            ),
            
            const SizedBox(height: BukeerSpacing.m),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    BukeerAnimations.createPageRoute(
                      page: const _DestinationPage('Scale Transition'),
                      type: PageTransitionType.scale,
                    ),
                  );
                },
                child: const Text('Scale Transition'),
              ),
            ),
            
            const SizedBox(height: BukeerSpacing.m),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    BukeerAnimations.createPageRoute(
                      page: const _DestinationPage('Material Transition'),
                      type: PageTransitionType.material,
                    ),
                  );
                },
                child: const Text('Material Transition'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationPage extends StatelessWidget {
  final String title;
  
  const _DestinationPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BukeerIconography.icon(
              BukeerIconography.success,
              size: IconSize.huge,
              color: BukeerColors.success,
            ),
            const SizedBox(height: BukeerSpacing.l),
            Text(
              'Transition Complete!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: BukeerColors.textPrimary,
              ),
            ),
            const SizedBox(height: BukeerSpacing.s),
            Text(
              'You used: $title',
              style: TextStyle(
                fontSize: 16,
                color: BukeerColors.textSecondary,
              ),
            ),
            const SizedBox(height: BukeerSpacing.xl),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}