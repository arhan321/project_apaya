<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class UserSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $timestamp = \Carbon\Carbon::now()->toDateTimeString(); 
        DB::table('users')->insert([
            [
                'name' => 'client',
                'email' => 'admin1@admin.com', 
                'password' => \Illuminate\Support\Facades\Hash::make('password'),
                'created_at' => $timestamp,
                'updated_at' => $timestamp,
            ],
            [
                'name' => 'arhan malik alrasyid',
                'email' => 'arhanmali96@gmail.com', 
                'password' => \Illuminate\Support\Facades\Hash::make('password'),
                'created_at' => $timestamp,
                'updated_at' => $timestamp,
            ],
        ]);
    }
}
