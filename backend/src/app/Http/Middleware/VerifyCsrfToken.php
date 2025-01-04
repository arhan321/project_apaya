<?php

namespace App\Http\Middleware;

use Log;
// use Illuminate\Support\Facades\Log;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;

class VerifyCsrfToken extends Middleware
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array
     */
    protected $except = [
     'api/*',
     'auth/logout',
     'password/email',
     'password/code/check',
     'password/reset',
    ];
    public function handle($request, \Closure $next)
    {
    if ($this->isReading($request) || $this->runningUnitTests() ||
        $this->inExceptArray($request) || $this->tokensMatch($request)) {
        Log::info('CSRF verification passed', [
            'url' => $request->fullUrl(),
            'method' => $request->method(),
            'headers' => $request->headers->all(),
            'body' => $request->all(),
        ]);
        return $next($request);
    }

    \Log::warning('CSRF verification failed', [
        'url' => $request->fullUrl(),
        'method' => $request->method(),
        'headers' => $request->headers->all(),
        'body' => $request->all(),
    ]);

    return parent::handle($request, $next);
    }

    
}