<?php

use Illuminate\Support\Facades\Route;

Route::group([
    'namespace' => 'Apokavkos\EveIntelligenceCenter\Http\Controllers',
    'prefix' => 'eveintelligencecenter',
    'middleware' => ['web', 'auth', 'locale'],
], function () {
    Route::get('/', 'DashboardController@index')->name('eveintelligencecenter::dashboard');
    Route::get('/assets', 'IndustryController@assets')->name('eveintelligencecenter::assets');

    Route::get('/stockpiles', 'StockpileController@index')->name('eveintelligencecenter::stockpiles');
    Route::get('/stockpiles/workflow', 'StockpileController@workflow')->name('eveintelligencecenter::stockpiles.workflow');
    Route::post('/stockpiles/from-requirements', 'StockpileController@createFromRequirements')->name('eveintelligencecenter::stockpiles.from-requirements');
    Route::post('/stockpiles', 'StockpileController@store')->name('eveintelligencecenter::stockpiles.store');
    Route::delete('/stockpiles/{id}', 'StockpileController@delete')->name('eveintelligencecenter::stockpiles.delete');
    Route::post('/stockpiles/items/{itemId}/location', 'StockpileController@updateItemLocation')->name('eveintelligencecenter::stockpiles.item.location');
    Route::get('/stockpiles/{id}/industry', 'StockpileController@industry')->name('eveintelligencecenter::stockpiles.industry');
    Route::get('/stockpiles/search/locations', 'StockpileController@searchLocations')->name('eveintelligencecenter::stockpiles.search.locations');

    // Industry Calculator
    Route::get('/industry', 'IndustryController@index')->name('eveintelligencecenter::industry.calculator');
    Route::get('/industry/guide', 'IndustryController@guide')->name('eveintelligencecenter::industry.guide');
    Route::post('/industry/calculate', 'IndustryController@calculate')->name('eveintelligencecenter::industry.calculate');
    Route::get('/industry/search', 'IndustryController@searchItems')->name('eveintelligencecenter::industry.search');
    Route::get('/industry/systems', 'IndustryController@searchSystems')->name('eveintelligencecenter::industry.systems');
    Route::get('/industry/system-index/{systemName}', 'IndustryController@getSystemIndex')->name('eveintelligencecenter::industry.system-index');
    Route::get('/industry/blueprints', 'IndustryController@listOwnedBlueprints')->name('eveintelligencecenter::industry.blueprints');
    Route::get('/industry/blueprint/{itemId}', 'IndustryController@getOwnedBlueprint')->name('eveintelligencecenter::industry.blueprint.detail');
    Route::get('/industry/warmup', 'IndustryController@warmup')->name('eveintelligencecenter::industry.warmup');

    // Reactions Planner
    Route::get('/reactions', 'ReactionController@index')->name('eveintelligencecenter::reactions.planner');
    Route::post('/reactions/calculate', 'ReactionController@calculate')->name('eveintelligencecenter::reactions.calculate');
    Route::post('/reactions/config', 'ReactionController@saveConfig')->name('eveintelligencecenter::reactions.config.save');
    Route::get('/reactions/warmup-prices', 'ReactionController@warmupPrices')->name('eveintelligencecenter::reactions.warmup-prices');

    // Market Dashboards
    Route::get('/market/markup', 'MarketController@markup')->name('eveintelligencecenter::market.markup');
    Route::get('/market/stock', 'MarketController@stock')->name('eveintelligencecenter::market.stock');
    Route::get('/market/doctrine', 'MarketController@doctrineDashboard')->name('eveintelligencecenter::market.doctrine');
    Route::match(['get', 'post'], '/market/fittings', 'MarketController@fittings')->name('eveintelligencecenter::market.fittings');
    Route::post('/market/fittings/save', 'MarketController@saveFit')->name('eveintelligencecenter::market.fittings.save');
    Route::post('/market/fittings/batch-restock', 'MarketController@batchRestock')->name('eveintelligencecenter::market.fittings.batch-restock');
    Route::post('/market/groups/save', 'MarketController@saveGroup')->name('eveintelligencecenter::market.groups.save');
    Route::delete('/market/groups/{id}', 'MarketController@deleteGroup')->name('eveintelligencecenter::market.groups.delete');
    Route::delete('/market/fittings/{id}', 'MarketController@deleteFit')->name('eveintelligencecenter::market.fittings.delete');

    Route::post('/market/exports/save', 'MarketController@saveExport')->name('eveintelligencecenter::market.exports.save');
    Route::delete('/market/exports/{id}', 'MarketController@deleteExport')->name('eveintelligencecenter::market.exports.delete');
    Route::get('/market/exports/dedupe', 'MarketController@dedupeExports')->name('eveintelligencecenter::market.exports.dedupe');

    Route::get('/market/hubs/search', 'MarketController@searchHubs')->name('eveintelligencecenter::market.hubs.search');
    Route::post('/market/hubs', 'MarketController@addHub')->name('eveintelligencecenter::market.hubs.add');
    Route::post('/market/hubs/sync/{hubId}', 'MarketController@syncHub')->name('eveintelligencecenter::market.hubs.sync');
    });
