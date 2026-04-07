<?php

return [
    '0eic' => [
        'name'          => 'Eve Intelligence Center',
        'label'         => 'Eve Intelligence Center',
        'icon'          => 'fas fa-boxes',
        'route_segment' => 'eveintelligencecenter',
        'entries'       => [
            [
                'name'  => 'Dashboard',
                'label' => 'Dashboard',
                'icon'  => 'fas fa-tachometer-alt',
                'route' => 'eveintelligencecenter::dashboard',
            ],
            [
                'name'  => 'Assets',
                'label' => 'Assets',
                'icon'  => 'fas fa-boxes',
                'route' => 'eveintelligencecenter::assets',
            ],
            [
                'name'  => 'Stockpile Workflow',
                'label' => 'Stockpile Workflow',
                'icon'  => 'fas fa-sync-alt',
                'route' => 'eveintelligencecenter::stockpiles.workflow',
            ],
            [
                'name'  => 'Stockpiles',
                'label' => 'Stockpiles',
                'icon'  => 'fas fa-layer-group',
                'route' => 'eveintelligencecenter::stockpiles',
            ],
            [
                'name'  => 'Industry Calculator',
                'label' => 'Industry Calculator',
                'icon'  => 'fas fa-calculator',
                'route' => 'eveintelligencecenter::industry.calculator',
            ],
            [
                'name'  => 'Reactions Planner',
                'label' => 'Reactions Planner',
                'icon'  => 'fas fa-vial',
                'route' => 'eveintelligencecenter::reactions.planner',
            ],
            [
                'name'  => 'Market: Markup Report',
                'label' => 'Markup Report',
                'icon'  => 'fas fa-percentage',
                'route' => 'eveintelligencecenter::market.markup',
            ],
            [
                'name'  => 'Market: Stock Health',
                'label' => 'Stock Health',
                'icon'  => 'fas fa-box-open',
                'route' => 'eveintelligencecenter::market.stock',
            ],
            [
                'name'  => 'Market: Doctrine Dashboard',
                'label' => 'Doctrine Dashboard',
                'icon'  => 'fas fa-shield-alt',
                'route' => 'eveintelligencecenter::market.doctrine',
            ],
            [
                'name'  => 'Market: Doctrine Importing',
                'label' => 'Doctrine Importing',
                'icon'  => 'fas fa-file-import',
                'route' => 'eveintelligencecenter::market.fittings',
            ],
            [
                'name'  => 'Stockpiles Guide',
                'label' => 'Stockpiles Guide',
                'icon'  => 'fas fa-book',
                'route' => 'eveintelligencecenter::industry.guide',
            ],
        ],
    ],
];
