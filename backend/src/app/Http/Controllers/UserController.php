<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function index(){
        $query = DB::connection('mysql')->table('users')->get();
        return response()->json($query, 200);
    }

    public function get_user(Request $request, $id){
        $user = User::where('id', $id)->first();
        if($user){
            $res['success'] = true;
            $res['message'] = $user;
            return response()->json($res, 200);
        } else {
            $res['success'] = false;
            $res['message'] = 'cannot find user';
            return response()->json($res, 404);
        }
    }
    
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => $validator->errors()
            ], 422);
        }

        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $user = Auth::user();

            return response()->json([
                'message' => 'Login successful',
                'user' => $user,
            ], 200);
        } else {
            return response()->json([
                'message' => 'Unauthorized, wrong email or password',
            ], 401);
        }
    }

    public function create(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:8',
        ]);

        $existingUserByName = User::where('name', $request->name)->first();
        if ($existingUserByName) {
            return response()->json([
                'message' => 'Nama sudah digunakan',
            ], 400);
        }

        $existingUserByEmail = User::where('email', $request->email)->first();
        if ($existingUserByEmail) {
            return response()->json([
                'message' => 'Email sudah digunakan',
            ], 400);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password, 
        ]);

        if ($user) {
            return response()->json(['message' => 'Akun berhasil terbuat!'], 201);
        } else {
            return response()->json(['message' => 'Gagal membuat akun karena masalah teknis'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:8',
        ]);

        $user = User::where('id', $id)->first();

        if ($user) {
            $user->name = $request->name;
            $user->email = $request->email;
            $user->password = bcrypt($request->password);
            $user->save();

            return response()->json(['message' => 'akun berhasil diupdate !!'], 200);
        } else {
            return response()->json(['message' => 'gagal update akun'], 500);
        }
    }

    public function delete($id)
    {
        $user = User::where('id', $id)->first();

        if ($user) {
            $user->delete();
            return response()->json(['message' => 'akun berhasil dihapus !!'], 200);
        } else {
            return response()->json(['message' => 'gagal menghapus akun'], 500);
        }
    }
}
