import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/page/effects_create/view.dart';
import 'package:flicko_video/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EffectsAllArgs {
  const EffectsAllArgs({required this.templates}); 

  final List<Template> templates;
}

class EffectsAllView extends StatefulWidget {
  const EffectsAllView({super.key, this.selectedCategoryId, this.templates});

  final int? selectedCategoryId;
  final List<Template>? templates;

  @override
  State<EffectsAllView> createState() => _EffectsAllViewState();
}

class _EffectsAllViewState extends State<EffectsAllView> {
  CreativeHome? _creativeHome;
  int? _selectedCategoryId;
  List<Template>? _templates;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
    _templates = widget.templates;
    if (_templates != null) {
      _loading = false;
      return;
    }
    _loadCreativeHome();
  }

  Future<void> _loadCreativeHome() async {
    setState(() {
      _loading = true;
    });

    try {
      final creativeHome = await Api.getCreativeHome();
      if (!mounted) {
        return;
      }

      final categories = creativeHome?.categories ?? [];
      final hasSelectedCategory = categories.any(
        (category) => category.id == _selectedCategoryId,
      );

      setState(() {
        _creativeHome = creativeHome;
        _selectedCategoryId = hasSelectedCategory
            ? _selectedCategoryId
            : (categories.isEmpty ? null : categories.first.id);
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = _creativeHome?.categories ?? [];
    final selectedCategory = _selectedCategory(categories);
    final templates = _templates ?? selectedCategory?.templates ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (_templates == null) _buildCategoryTabs(categories),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF),
                        strokeWidth: 2,
                      ),
                    )
                  : _buildTemplateGrid(templates, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Category? _selectedCategory(List<Category> categories) {
    if (categories.isEmpty) {
      return null;
    }

    for (final category in categories) {
      if (category.id == _selectedCategoryId) {
        return category;
      }
    }
    return categories.first;
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const Text(
            'Select Template',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(List<Category> categories) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == _selectedCategoryId;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryId = category.id;
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF56607A)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                category.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTemplateGrid(List<Template> templates, AppLocalizations l10n) {
    if (templates.isEmpty) {
      return Center(
        child: Text(
          l10n.noWorks,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _buildTemplateCard(template, templates);
      },
    );
  }

  Widget _buildTemplateCard(Template template, List<Template> templates) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/effects_create',
          extra: EffectsCreateArgs(
            templates: templates,
            selectedTemplateId: template.id,
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            imageUrl: template.animation ?? template.cover ?? '',
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(8),
            placeholderColor: const Color(0xFF1A1A2E),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Text(
              template.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
