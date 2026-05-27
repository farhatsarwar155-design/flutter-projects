import 'dart:io' as dart_io;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/helpers/date_helper.dart';
import '../../models/note_model.dart';
import '../../providers/notes_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../models/reminder_model.dart';
import '../../widgets/cards/priority_badge.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/dialogs/confirmation_dialog.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteModel? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  late String _category;
  late String _priority;
  late int _colorValue;
  late bool _isPinned;
  late bool _isFavorite;
  late bool _isArchived;
  List<String> _tags = [];
  List<String> _imagePaths = [];
  String? _voicePath;
  DateTime? _reminderDate;
  bool _isEditing = false;
  bool _saving = false;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlayingVoice = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.note != null;
    final n = widget.note;
    _titleCtrl.text = n?.title ?? '';
    _subtitleCtrl.text = n?.subtitle ?? '';
    _descCtrl.text = n?.description ?? '';
    _category = n?.category ?? 'Personal';
    _priority = n?.priority ?? AppConstants.priorityLow;
    _colorValue = n?.colorValue ?? 0xFFFFFFFF;
    _isPinned = n?.isPinned ?? false;
    _isFavorite = n?.isFavorite ?? false;
    _isArchived = n?.isArchived ?? false;
    _tags = List.from(n?.tags ?? []);
    _imagePaths = List.from(n?.imagePaths ?? []);
    _voicePath = n?.voicePath;
    _reminderDate = n?.reminderDate;

    _titleCtrl.addListener(_onChanged);
    _descCtrl.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descCtrl.dispose();
    _tagCtrl.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      AppSnackbar.show(context, 'Title cannot be empty',
          type: SnackbarType.error);
      return;
    }
    setState(() => _saving = true);
    final prov = context.read<NotesProvider>();

    try {
      if (_isEditing) {
        final updated = widget.note!.copyWith(
          title: _titleCtrl.text.trim(),
          subtitle: _subtitleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          category: _category,
          priority: _priority,
          tags: _tags,
          colorValue: _colorValue,
          imagePaths: _imagePaths,
          voicePath: _voicePath,
          isPinned: _isPinned,
          isFavorite: _isFavorite,
          isArchived: _isArchived,
          reminderDate: _reminderDate,
          clearReminder: _reminderDate == null,
          updatedAt: DateTime.now(),
        );
        await prov.updateNote(updated);

        if (_reminderDate != null) {
          final remProv = context.read<ReminderProvider>();
          await remProv.removeReminderByNote(widget.note!.id);
          await remProv.addReminder(
              ReminderModel(noteId: widget.note!.id, noteTitle: _titleCtrl.text.trim(), dateTime: _reminderDate!));


        }} else {
        final note = await prov.createNote(
          title: _titleCtrl.text.trim(),
          subtitle: _subtitleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          category: _category,
          priority: _priority,
          tags: _tags,
          colorValue: _colorValue,
          imagePaths: _imagePaths,
          voicePath: _voicePath,
          reminderDate: _reminderDate,
        );
        if (_reminderDate != null) {
          await context.read<ReminderProvider>().addReminder(
              ReminderModel(noteId: note.id, noteTitle: _titleCtrl.text.trim(), dateTime: _reminderDate!)
          );
        }
      }
      if (mounted) {
        setState(() => _saving = false);
        await context.read<DashboardProvider>().loadDashboard(); // ⬅️ add

        final hasReminder = _reminderDate != null;
        final message = _isEditing
            ? (hasReminder ? 'Note updated! Reminder set ✅' : 'Note updated!')
            : (hasReminder ? 'Note saved! Reminder set ✅' : 'Note saved!');

        AppSnackbar.show(
          context,
          message,
          type: SnackbarType.success,
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        AppSnackbar.show(context, 'Error saving note: $e', type: SnackbarType.error);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final imgs = await picker.pickMultiImage(imageQuality: 80);
    if (imgs.isNotEmpty)
      setState(() {
        _imagePaths.addAll(imgs.map((e) => e.path));
      });
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final img =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (img != null)
      setState(() {
        _imagePaths.add(img.path);
      });
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_rounded,
                    color: AppColors.primary),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded,
                    color: AppColors.primary),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleVoiceRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        if (path != null) _voicePath = path;
      });
      AppSnackbar.show(context, 'Voice note saved!',
          type: SnackbarType.success);
    } else {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        AppSnackbar.show(context, 'Microphone permission denied',
            type: SnackbarType.error);
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(const RecordConfig(), path: filePath);
      setState(() => _isRecording = true);
      AppSnackbar.show(context, 'Recording... tap mic again to stop',
          type: SnackbarType.info);
    }
  }

  Future<void> _togglePlayVoice() async {
    if (_voicePath == null) return;
    if (_isPlayingVoice) {
      await _audioPlayer.stop();
      setState(() => _isPlayingVoice = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(_voicePath!));
      setState(() => _isPlayingVoice = true);
      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _isPlayingVoice = false);
      });
    }
  }

  Future<void> _pickReminder() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? now.add(const Duration(hours: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() {
      _reminderDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pick Note Color',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppColors.noteCardColors.map((c) {
                final isSelected = c.value == _colorValue;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _colorValue = c.value;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.withOpacity(0.3),
                          width: isSelected ? 3 : 1),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                        color: AppColors.primary, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _addTag() {
    final tag = _tagCtrl.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagCtrl.clear();
      });
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Move to Trash?',
      message: 'This note will be moved to trash.',
      confirmText: 'Move to Trash',
      icon: Icons.delete_outline_rounded,
    );
    if (confirm == true && mounted) {
      await context.read<NotesProvider>().moveToTrash(widget.note!);
      if (!mounted) return;
      await context.read<DashboardProvider>().loadDashboard();
      AppSnackbar.show(context, 'Moved to trash', type: SnackbarType.warning);
      Navigator.pop(context);
    }
  }

  Future<void> _handleDuplicate() async {
    await context.read<NotesProvider>().duplicateNote(widget.note!);
    if (!mounted) return;
    AppSnackbar.show(context, 'Note duplicated', type: SnackbarType.success);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = _colorValue == 0xFFFFFFFF && isDark
        ? AppColors.darkBackground
        : Color(_colorValue);
    final isLightBg = bgColor.computeLuminance() > 0.5;
    final textColor = isLightBg ? Colors.black87 : Colors.white;
    final hintColor = isLightBg ? Colors.black38 : Colors.white54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_isEditing ? 'Edit Note' : 'New Note',
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: Icon(
                  _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                  color: textColor),
              onPressed: () => setState(() {
                _isPinned = !_isPinned;
              }),
              tooltip: _isPinned ? 'Unpin' : 'Pin',
            ),
            IconButton(
              icon: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: _isFavorite ? AppColors.secondary : textColor),
              onPressed: () => setState(() {
                _isFavorite = !_isFavorite;
              }),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, color: textColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'delete') _handleDelete();
                if (v == 'duplicate') _handleDuplicate();
                if (v == 'archive') {
                  context.read<NotesProvider>().archiveNote(widget.note!);
                  Navigator.pop(context);
                }
              },
              itemBuilder: (_) => [
                _menuItem('duplicate', Icons.copy_rounded, 'Duplicate'),
                _menuItem('archive', Icons.archive_rounded, 'Archive'),
                _menuItem(
                    'delete', Icons.delete_outline_rounded, 'Move to Trash',
                    color: AppColors.error),
              ],
            ),
          ],
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primary))
                : const Text('Save',
                style:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: textColor),
              decoration: InputDecoration(
                hintText: 'Note Title',
                hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: hintColor),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _subtitleCtrl,
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.8)),
              decoration: InputDecoration(
                hintText: 'Subtitle (optional)',
                hintStyle: TextStyle(fontSize: 16, color: hintColor),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const Divider(height: 24),
            _buildMetaRow(textColor, hintColor),
            const SizedBox(height: 20),
            TextField(
              controller: _descCtrl,
              style: TextStyle(fontSize: 15, color: textColor, height: 1.6),
              decoration: InputDecoration(
                hintText: 'Write your note here...',
                hintStyle: TextStyle(color: hintColor, fontSize: 15),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
              minLines: 8,
            ),
            const SizedBox(height: 20),
            _buildTagsSection(textColor, hintColor),
            const SizedBox(height: 16),
            if (_imagePaths.isNotEmpty) _buildImagesPreview(),
            const SizedBox(height: 20),
            if (_reminderDate != null) _buildReminderChip(hintColor),
            if (_voicePath != null) _buildVoicePlayer(),
            const SizedBox(height: 24),
            _buildToolbar(textColor),
            const SizedBox(height: 12),
            if (_isEditing && widget.note != null)
              Text(
                'Created ${DateHelper.formatDateTime(widget.note!.createdAt)}',
                style: TextStyle(fontSize: 11, color: hintColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(Color textColor, Color hintColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Consumer<CategoryProvider>(
          builder: (_, cats, __) => GestureDetector(
            onTap: () => _showCategoryPicker(cats.categoryNames),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.folder_rounded, size: 14),
                const SizedBox(width: 5),
                Text(_category,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor)),
              ]),
            ),
          ),
        ),
        GestureDetector(
          onTap: _showPriorityPicker,
          child: PriorityBadge(priority: _priority),
        ),
        GestureDetector(
          onTap: _showColorPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                      color: Color(_colorValue),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withOpacity(0.4)))),
              const SizedBox(width: 5),
              Text('Color',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(Color textColor, Color hintColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_tags.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _tags
                .map((t) => Chip(
              label: Text('#$t',
                  style: TextStyle(fontSize: 12, color: textColor)),
              backgroundColor: textColor.withOpacity(0.1),
              deleteIcon: Icon(Icons.close_rounded,
                  size: 14, color: textColor.withOpacity(0.6)),
              onDeleted: () => setState(() {
                _tags.remove(t);
              }),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ))
                .toList(),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagCtrl,
                style: TextStyle(fontSize: 13, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Add tag...',
                  hintStyle: TextStyle(color: hintColor, fontSize: 13),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  prefixIcon:
                  Icon(Icons.tag_rounded, size: 16, color: hintColor),
                  prefixIconConstraints: const BoxConstraints(minWidth: 28),
                ),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            if (_tagCtrl.text.isNotEmpty)
              IconButton(
                  icon: Icon(Icons.add_circle_rounded,
                      color: textColor, size: 20),
                  onPressed: _addTag),
          ],
        ),
      ],
    );
  }

  Widget _buildImagesPreview() {
    return Column(
      children: _imagePaths.asMap().entries.map((entry) {
        final i = entry.key;
        final path = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  dart_io.File(path),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.withOpacity(0.2),
                    child: const Center(
                        child: Icon(Icons.broken_image_outlined, size: 48)),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => _imagePaths.removeAt(i)),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.black54, shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVoicePlayer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          onTap: _togglePlayVoice,
          child: Icon(
            _isPlayingVoice
                ? Icons.stop_circle_rounded
                : Icons.play_circle_rounded,
            size: 22,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        const Text('Voice Note',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() {
            _voicePath = null;
            _isPlayingVoice = false;
          }),
          child: const Icon(Icons.close_rounded,
              size: 14, color: AppColors.primary),
        ),
      ]),
    );
  }

  Widget _buildReminderChip(Color hintColor) {
    return GestureDetector(
      onTap: _pickReminder,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.alarm_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(DateHelper.formatDateTime(_reminderDate!),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => setState(() => _reminderDate = null),
            child: const Icon(Icons.close_rounded,
                size: 14, color: AppColors.primary),
          ),
        ]),
      ),
    );
  }

  Widget _buildToolbar(Color textColor) {
    return Row(
      children: [
        _toolbarBtn(Icons.image_outlined, 'Image', _showImageSourcePicker, textColor),
        _toolbarBtn(
            Icons.alarm_add_rounded, 'Reminder', _pickReminder, textColor),
        _toolbarBtn(
            Icons.attach_file_rounded,
            'Attach',
            _showImageSourcePicker,
            textColor),
        _toolbarBtn(
            _isRecording ? Icons.stop_circle_rounded : Icons.mic_outlined,
            _isRecording ? 'Stop' : 'Voice',
            _toggleVoiceRecording,
            _isRecording ? Colors.red : textColor),
      ],
    );
  }

  Widget _toolbarBtn(
      IconData icon, String tooltip, VoidCallback onTap, Color color) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color.withOpacity(0.7), size: 22),
        onPressed: onTap,
      ),
    );
  }

  void _showCategoryPicker(List<String> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text('Select Category',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...categories.map((c) => ListTile(
            title: Text(c),
            trailing: _category == c
                ? const Icon(Icons.check_circle_rounded,
                color: AppColors.primary)
                : null,
            onTap: () {
              setState(() {
                _category = c;
              });
              Navigator.pop(context);
            },
          )),
        ],
      ),
    );
  }

  void _showPriorityPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text('Select Priority',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...AppConstants.priorities.map((p) => ListTile(
            leading: PriorityBadge(priority: p),
            trailing: _priority == p
                ? const Icon(Icons.check_circle_rounded,
                color: AppColors.primary)
                : null,
            onTap: () {
              setState(() {
                _priority = p;
              });
              Navigator.pop(context);
            },
          )),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label,
      {Color? color}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(label, style: color != null ? TextStyle(color: color) : null),
        ],
      ),
    );
  }
}