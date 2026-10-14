import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../services/avatar_service.dart';
import '../../widgets/section_card.dart';
import '../../widgets/user_avatar.dart';

/// Editable personal details: name, phone (OTP flow), address, photo.
/// Email is read-only (Supabase-managed).
class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState
    extends ConsumerState<PersonalDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final _otpController = TextEditingController();

  bool _editingName = false;
  bool _editingPhone = false;
  bool _editingAddress = false;
  bool _otpSent = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    // Merge DB-side fields (address, phone mirror) into local state.
    Future.microtask(() async {
      await ref.read(authProvider.notifier).fetchMe();
      if (!mounted) return;
      final fresh = ref.read(authProvider).user;
      setState(() {
        if (!_editingName) _nameController.text = fresh?.displayName ?? '';
        if (!_editingPhone && !_otpSent) {
          _phoneController.text = fresh?.phone ?? '';
        }
        if (!_editingAddress) _addressController.text = fresh?.address ?? '';
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _snack(String message, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<bool> _confirm(String title, String message, String actionLabel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
    return result == true;
  }

  // ─── Name ────────────────────────────────────────────────────────────────

  Future<void> _saveName() async {
    final ok = await _confirm(
      'Update display name?',
      'Are you sure you want to update your display name?',
      'Update',
    );
    if (!ok || !mounted) return;

    setState(() => _busy = true);
    final error =
        await ref.read(authProvider.notifier).updateDisplayName(_nameController.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (error == null) _editingName = false;
    });
    if (error != null) {
      _snack(error);
    } else {
      _snack('Display name updated', success: true);
    }
  }

  // ─── Phone (OTP flow) ────────────────────────────────────────────────────

  Future<void> _sendPhoneCode() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _snack('Enter a phone number first');
      return;
    }
    final ok = await _confirm(
      'Update phone number?',
      'We\'ll send a verification code to $phone.',
      'Send code',
    );
    if (!ok || !mounted) return;

    setState(() => _busy = true);
    final error = await ref.read(authProvider.notifier).changePhone(phone);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (error == null) _otpSent = true;
    });
    if (error != null) {
      _snack(error);
    } else {
      _snack('Verification code sent to $phone', success: true);
    }
  }

  Future<void> _verifyPhone() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _snack('Enter the verification code');
      return;
    }

    setState(() => _busy = true);
    final error = await ref
        .read(authProvider.notifier)
        .verifyPhoneChange(_phoneController.text.trim(), otp);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (error == null) {
        _otpSent = false;
        _editingPhone = false;
        _otpController.clear();
      }
    });
    if (error != null) {
      _snack(error);
    } else {
      _snack('Phone number updated', success: true);
    }
  }

  // ─── Address ─────────────────────────────────────────────────────────────

  Future<void> _saveAddress() async {
    final ok = await _confirm(
      'Update address?',
      'Are you sure you want to update your residential address?',
      'Update',
    );
    if (!ok || !mounted) return;

    setState(() => _busy = true);
    final error =
        await ref.read(authProvider.notifier).updateAddress(_addressController.text.trim());
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (error == null) _editingAddress = false;
    });
    if (error != null) {
      _snack(error);
    } else {
      _snack('Address updated', success: true);
    }
  }

  // ─── Photo ───────────────────────────────────────────────────────────────

  Future<void> _changePhoto() async {
    final source = await AvatarService.pickSource(context);
    if (source == null || !mounted) return;

    setState(() => _busy = true);
    final userId = ref.read(authProvider).user?.id;
    final result = await AvatarService.pickAndUpload(source, userId: userId);
    if (!mounted) return;
    setState(() => _busy = false);

    if (result.ok && result.url != null) {
      await ref.read(authProvider.notifier).updateAvatar(result.url!);
      _snack('Profile photo updated!', success: true);
    } else if (result.error != null) {
      _snack(result.error!);
    }
  }

  Future<void> _removePhoto() async {
    final ok = await _confirm(
      'Remove Photo',
      'Are you sure you want to remove your profile photo?',
      'Remove',
    );
    if (!ok || !mounted) return;

    setState(() => _busy = true);
    final userId = ref.read(authProvider).user?.id;
    final result = await AvatarService.deleteAll(userId);
    if (!mounted) return;

    if (result.ok) {
      await ref.read(authProvider.notifier).deleteAvatar();
      _snack('Profile photo removed', success: true);
    } else {
      _snack(result.error ?? 'Delete failed');
    }
    if (mounted) setState(() => _busy = false);
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final hasBottomNav = size.width < AppConstants.tabletBreakpoint;

    final displayName = user?.displayName ??
        user?.email?.split('@').first ??
        'User';

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        hasBottomNav ? (isMobile ? 16 : 24) + 76 : (isMobile ? 16 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Personal Details',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep your profile up to date.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // ─── Photo ──────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      UserAvatar(
                        avatarUrl: user?.avatarUrl,
                        displayName: displayName,
                        radius: 40,
                        fallbackIcon: Icons.account_circle_outlined,
                        iconSize: 40,
                      ),
                      if (_busy)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _busy ? null : _changePhoto,
                        icon: const Icon(Icons.photo_camera_outlined, size: 18),
                        label: const Text('Change photo'),
                      ),
                      if (user?.avatarUrl != null &&
                          user!.avatarUrl!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: _busy ? null : _removePhoto,
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Remove'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ─── Display name ───────────────────────────────────────────
          SectionCard(
            icon: Icons.badge_outlined,
            title: 'Display Name',
            trailing: _editingName
                ? null
                : TextButton(
                    onPressed: () => setState(() => _editingName = true),
                    child: const Text('Edit'),
                  ),
            child: _editingName
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(isDense: true, hintText: 'Your name'),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() {
                                      _editingName = false;
                                      _nameController.text =
                                          user?.displayName ?? '';
                                    }),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _busy ? null : _saveName,
                            child: _busy
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    user?.displayName?.isNotEmpty == true
                        ? user!.displayName!
                        : 'Not set',
                    style: theme.textTheme.bodyLarge,
                  ),
          ),
          const SizedBox(height: 16),

          // ─── Phone ──────────────────────────────────────────────────
          SectionCard(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            trailing: _editingPhone
                ? null
                : TextButton(
                    onPressed: () => setState(() => _editingPhone = true),
                    child: const Text('Edit'),
                  ),
            child: _editingPhone
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: '+2348012345678',
                          prefixText: '',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      if (_otpSent) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: _otpController,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: '6-digit verification code',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() {
                                      _editingPhone = false;
                                      _otpSent = false;
                                      _phoneController.text = user?.phone ?? '';
                                      _otpController.clear();
                                    }),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _busy
                                ? null
                                : _otpSent
                                    ? _verifyPhone
                                    : _sendPhoneCode,
                            child: _busy
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(_otpSent ? 'Verify' : 'Send code'),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.phone?.isNotEmpty == true
                            ? user!.phone!
                            : 'Not set',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Changing your phone requires an SMS verification code.',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),

          // ─── Address ────────────────────────────────────────────────
          SectionCard(
            icon: Icons.home_outlined,
            title: 'Residential Address',
            trailing: _editingAddress
                ? null
                : TextButton(
                    onPressed: () => setState(() => _editingAddress = true),
                    child: const Text('Edit'),
                  ),
            child: _editingAddress
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'e.g. 12 Admiralty Way, Lekki, Lagos',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() {
                                      _editingAddress = false;
                                      _addressController.text =
                                          user?.address ?? '';
                                    }),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _busy ? null : _saveAddress,
                            child: _busy
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    user?.address?.isNotEmpty == true
                        ? user!.address!
                        : 'Not set',
                    style: theme.textTheme.bodyLarge,
                  ),
          ),
          const SizedBox(height: 16),

          // ─── Email (read-only) ──────────────────────────────────────
          SectionCard(
            icon: Icons.mail_outline,
            title: 'Email',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.email ?? 'Not set',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.lock_outline,
                        size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Your sign-in email can\'t be changed here. '
                        'Contact support for help.',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
