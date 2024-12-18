<?php

use App\Models\User;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
// use Illuminate\Routing\Route;
use Illuminate\Support\Facades\Auth;
// use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Password;
use Illuminate\Auth\Events\PasswordReset;

/*
|----------------------------------------------------------------------
| Web Routes
|----------------------------------------------------------------------
*/

Route::get('/', function () {
    return view('welcome');
});

/*------------------------
    AUTH ROUTES
------------------------*/
Auth::routes();

/*------------------------
    PASSWORD RESET
------------------------*/
// Halaman permintaan reset password
Route::get('/forgot-password', function () {
    return view('auth.passwords.email');
})->name('password.request');

// Mengirimkan email untuk reset password
Route::post('/forgot-password', function (Request $request) {
    $request->validate(['email' => 'required|email']);

    $status = Password::sendResetLink($request->only('email'));

    return $status === Password::RESET_LINK_SENT
        ? back()->with(['status' => __($status)])
        : back()->withErrors(['email' => __($status)]);
})->name('password.email');

// Halaman form reset password
Route::get('/reset-password/{token}', function (string $token) {
    return view('auth.passwords.reset', ['token' => $token]);
})->name('password.reset');

// Mengirimkan form reset password
Route::post('/reset-password', function (Request $request) {
    $request->validate([
        'token' => 'required',
        'email' => 'required|email',
        'password' => 'required|min:8|confirmed',
    ]);

    $status = Password::reset(
        $request->only('email', 'password', 'password_confirmation', 'token'),
        function (User $user, string $password) {
            $user->forceFill([
                'password' => Hash::make($password)
            ])->setRememberToken(Str::random(60));

            $user->save();

            event(new PasswordReset($user));
        }
    );

    return $status === Password::PASSWORD_RESET
        ? redirect()->route('login')->with('status', __($status))
        : back()->withErrors(['email' => [__($status)]]);
})->name('password.update');

/*------------------------
    BACKOFFICE ROUTES
------------------------*/
Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');



// api absen

//CRUD
Route::group(['prefix' => 'api/v1/account'], function() {
    Route::get('/', [AuthController::class, 'index']);
    Route::get('/{id}', [AuthController::class, 'get_user']);
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::put('/{id}', [AuthController::class, 'update']);
    Route::delete('/{id}', [AuthController::class, 'delete']);
});

