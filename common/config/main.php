<?php

use common\components\ch\Connection;
use yii\caching\FileCache;

return [
    'aliases' => [
        '@bower' => '@vendor/bower-asset',
        '@npm' => '@vendor/npm-asset',
    ],
    'vendorPath' => dirname(dirname(__DIR__)) . '/vendor',
    'components' => [
        'cache' => [
            'class' => FileCache::class,
        ],
        'cHouse' => [
            'class' => Connection::class,
            'host' => 'clickhouse',
            'port' => '8123',
            'username' => 'default',
            'pwd' => '',
            'db' => 'menus'
        ]
    ],
];
