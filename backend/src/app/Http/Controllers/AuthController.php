<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;

class AuthController extends Controller
{
    // Tampilkan form login
    public function showLoginForm()
    {
        return view('function.login');
    }

    // Proses login
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:8',
        ]);

        if (Auth::attempt($request->only('email', 'password'))) {
            return redirect()->intended('/home')->with('success', 'Login successful');
        }

        return back()->withErrors(['email' => 'Invalid credentials'])->withInput();
    }

    // Tampilkan form reset password
    public function showResetPasswordForm()
    {
        return view('function.password-reset');
    }

    // Kirim email reset password
    public function sendResetPasswordLink(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);
    
        $status = Password::sendResetLink($request->only('email'));
    
        if ($status === Password::RESET_LINK_SENT) {
            return back()->with('status', __($status));
        }
    
        return back()->withErrors(['email' => __($status)]);
    }

    // Tampilkan form untuk reset password dengan token
    public function showResetForm($token)
    {
        dd($token); 
        return view('auth.passwords.reset', ['token' => $token]);
    }

    // Proses reset password
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:8|confirmed',
            'token' => 'required',
        ]);
    
        // Melakukan reset password
        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user) use ($request) {
                $user->password = Hash::make($request->password);
                $user->save();
            }
        );
    
        if ($status === Password::PASSWORD_RESET) {
            return redirect()->route('login')->with('status', 'Password has been reset!');
        }
    
        return back()->withErrors(['email' => __($status)]);
    }
}
