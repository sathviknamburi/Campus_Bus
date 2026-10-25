import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../data/mock_transit_data.dart';
import '../models/student_model.dart';

/// Authentication state provider for SRKR Engineering College Bus Tracking.
/// Enforces:
/// - Registration pattern: 24B91AXXXX (case-insensitive, 10 characters)
/// - Password match: password must be identical to the registration number
/// - Student assigned bus binding
/// - Offline session persistence via SharedPreferences (Phase 3)
class AuthProvider extends ChangeNotifier {
  static const String _prefKeyIsLoggedIn = 'srkr_auth_is_logged_in';
  static const String _prefKeyStudentData = 'srkr_auth_student_data';
  static const String _prefKeyIsGuest = 'srkr_auth_is_guest';

  bool _isInitialized = false;
  bool _isLoggedIn = false;
  bool _isGuestMode = false;
  StudentModel? _currentStudent;
  String? _authErrorMessage;
  bool _isLoading = false;

  AuthProvider() {
    loadSavedSession();
  }

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuestMode => _isGuestMode;
  StudentModel? get currentStudent => _currentStudent;
  String? get authErrorMessage => _authErrorMessage;
  bool get isLoading => _isLoading;

  /// Returns true if student is authenticated with an assigned bus
  bool get isStudentAuthenticated => _isLoggedIn && _currentStudent != null;

  /// The assigned bus ID for the authenticated student, or null if guest
  String? get assignedBusId => _currentStudent?.assignedBusId;

  // ===========================================================================
  // SESSION INITIALIZATION & PERSISTENCE (PHASE 3)
  // ===========================================================================

  Future<void> loadSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_prefKeyIsLoggedIn) ?? false;
      final studentJson = prefs.getString(_prefKeyStudentData);
      final isGuest = prefs.getBool(_prefKeyIsGuest) ?? false;

      if (isLoggedIn && studentJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(studentJson) as Map<String, dynamic>;
        _currentStudent = StudentModel.fromJson(decoded);
        _isLoggedIn = true;
        _isGuestMode = false;
      } else if (isGuest) {
        _isGuestMode = true;
        _isLoggedIn = false;
      }
    } catch (e) {
      debugPrint('Error restoring saved SRKR session: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // ===========================================================================
  // AUTHENTICATION LOGIC (STUDENT LOGIN)
  // ===========================================================================

  /// Validates format and logs in the student.
  /// Returns null on success, or an error string on failure.
  Future<String?> login({
    required String regNo,
    required String password,
  }) async {
    _isLoading = true;
    _authErrorMessage = null;
    notifyListeners();

    // Artificial short delay for realistic auth feedback
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final trimmedRegNo = regNo.trim();
    final trimmedPassword = password.trim();

    // 1. Check for empty fields
    if (trimmedRegNo.isEmpty) {
      _authErrorMessage = 'Please enter your Registration Number';
      _isLoading = false;
      notifyListeners();
      return _authErrorMessage;
    }

    if (trimmedPassword.isEmpty) {
      _authErrorMessage = 'Please enter your Password';
      _isLoading = false;
      notifyListeners();
      return _authErrorMessage;
    }

    // 2. Validate Registration Number Regex Pattern (24B91AXXXX)
    final normalizedRegNo = trimmedRegNo.toUpperCase();
    if (!AppConstants.studentRegNoRegex.hasMatch(normalizedRegNo)) {
      _authErrorMessage =
          'Registration number must follow the SRKR pattern: 24B91AXXXX (e.g. 24B91A0501)';
      _isLoading = false;
      notifyListeners();
      return _authErrorMessage;
    }

    // 3. Validate Password match rule (Password must match Registration Number)
    if (trimmedPassword.toUpperCase() != normalizedRegNo) {
      _authErrorMessage =
          'Password must be identical to your Registration Number ($normalizedRegNo)';
      _isLoading = false;
      notifyListeners();
      return _authErrorMessage;
    }

    // 4. Resolve or generate Student profile with bound assigned bus
    final student = MockTransitData.getStudentByRegNo(normalizedRegNo);
    _currentStudent = student;
    _isLoggedIn = true;
    _isGuestMode = false;
    _authErrorMessage = null;
    _isLoading = false;

    // 5. Persist student session to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyIsLoggedIn, true);
      await prefs.setString(_prefKeyStudentData, jsonEncode(student.toJson()));
      await prefs.setBool(_prefKeyIsGuest, false);
    } catch (e) {
      debugPrint('Error saving session: $e');
    }

    notifyListeners();
    return null;
  }

  /// Continue exploration as Guest / Non-user to view intro & route guide
  Future<void> continueAsGuest() async {
    _isLoggedIn = false;
    _isGuestMode = true;
    _currentStudent = null;
    _authErrorMessage = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyIsLoggedIn, false);
      await prefs.remove(_prefKeyStudentData);
      await prefs.setBool(_prefKeyIsGuest, true);
    } catch (_) {}

    notifyListeners();
  }

  /// Log out and return to the Non-User Introduction & Login screen
  Future<void> logout() async {
    _isLoggedIn = false;
    _isGuestMode = false;
    _currentStudent = null;
    _authErrorMessage = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (_) {}

    notifyListeners();
  }

  /// Switch assigned boarding stop (for student preference customization)
  void updateBoardingStop(String newStop) {
    if (_currentStudent == null) return;
    _currentStudent = StudentModel(
      regNo: _currentStudent!.regNo,
      name: _currentStudent!.name,
      branch: _currentStudent!.branch,
      year: _currentStudent!.year,
      assignedBusId: _currentStudent!.assignedBusId,
      assignedBusNumber: _currentStudent!.assignedBusNumber,
      assignedRouteId: _currentStudent!.assignedRouteId,
      assignedRouteName: _currentStudent!.assignedRouteName,
      boardingStop: newStop,
      destination: _currentStudent!.destination,
      studentPhone: _currentStudent!.studentPhone,
      parentPhone: _currentStudent!.parentPhone,
      busPassValidity: _currentStudent!.busPassValidity,
    );

    // Save updated student profile
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_prefKeyStudentData, jsonEncode(_currentStudent!.toJson()));
    });

    notifyListeners();
  }
}
