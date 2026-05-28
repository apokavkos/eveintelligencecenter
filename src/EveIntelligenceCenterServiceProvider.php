<?php

namespace Apokavkos\EveIntelligenceCenter;

use Seat\Services\AbstractSeatPlugin;

class EveIntelligenceCenterServiceProvider extends AbstractSeatPlugin
{
    public function boot()
    {
        $this->loadRoutesFrom(__DIR__ . '/Http/routes.php');
        $this->loadViewsFrom(__DIR__ . '/resources/views', 'eveintelligencecenter');
        $this->loadMigrationsFrom(__DIR__ . '/database/migrations');

        $this->publishes([
            __DIR__ . '/Config/Permissions/eic.permissions.php' => config_path('eic.permissions.php'),
        ]);
    }

    public function register()
    {
        $this->mergeConfigFrom(__DIR__ . '/Config/package.sidebar.php', 'package.sidebar');
        $this->registerPermissions(__DIR__ . '/Config/Permissions/eic.permissions.php', 'eic');
    }

    public function getName(): string
    {
        return "Eve Intelligence Center";
    }

    public function getPackageRepositoryUrl(): string
    {
        return 'https://github.com/apokavkos/eveintelligencecenter';
    }

    public function getPackagistPackageName(): string
    {
        return 'apokavkos/eveintelligencecenter';
    }

    public function getPackagistVendorName(): string
    {
        return 'apokavkos';
    }
}
