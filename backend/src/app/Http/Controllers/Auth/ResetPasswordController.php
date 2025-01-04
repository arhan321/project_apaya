<?php

namespace App\Http\Controllers\Auth;

use Exception;
use Illuminate\Http\Request;
use App\Models\ResetCodePassword;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\ApiController;

class ResetPasswordController extends ApiController
{
    /**
     * Handle the reset password process (Step 3).
     *
     * @param  Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function __invoke(Request $request)
    {
        DB::beginTransaction();

        try {
            // Log bahwa request diterima
            Log::info('Reset password request received', [
                'code' => $request->code,
                'email' => $request->email,
            ]);

            // Validasi input
            $validatedData = $request->validate([
                'code' => 'required|string|exists:reset_code_passwords,code',
                'email' => 'required|email|exists:users,email',
                'password' => 'required|string|min:6',
            ]);

            // Cari kode reset password
            $passwordReset = ResetCodePassword::where('code', $validatedData['code'])
                ->where('email', $validatedData['email'])
                ->first();

            if (!$passwordReset) {
                Log::warning('Invalid reset code or email mismatch', [
                    'code' => $validatedData['code'],
                    'email' => $validatedData['email'],
                ]);
                return $this->jsonResponse(null, trans('passwords.code_invalid'), 404);
            }

            // Cek apakah kode sudah kadaluarsa
            if ($passwordReset->isExpire()) {
                Log::warning('Reset code expired', ['code' => $validatedData['code']]);
                $passwordReset->delete();
                return $this->jsonResponse(null, trans('passwords.code_is_expire'), 422);
            }

            // Perbarui password langsung di tabel `users`
            $updated = DB::table('users')
                ->where('email', $validatedData['email'])
                ->update(['password' => Hash::make($validatedData['password'])]);

            if (!$updated) {
                Log::error('Failed to update password for user', ['email' => $validatedData['email']]);
                return $this->jsonResponse(null, 'Failed to reset password.', 500);
            }

            Log::info('User password updated successfully', ['email' => $validatedData['email']]);

            // Hapus kode reset yang sudah digunakan
            $passwordReset->delete();
            Log::info('Reset code deleted after successful password reset', [
                'code' => $validatedData['code'],
                'email' => $validatedData['email'],
            ]);

            DB::commit();

            // Kembalikan respon sukses
            return $this->jsonResponse(null, trans('site.password_has_been_successfully_reset'), 200);

        } catch (Exception $e) {
            DB::rollBack();

            // Tangkap semua error tak terduga
            Log::error('Unexpected error during password reset', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
            return response()->json([
                'message' => 'An unexpected error occurred. Please try again later.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
