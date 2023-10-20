<?php

/** @var yii\web\View $this
 * @var $searchModel AverageHistoricalPricesDishes
 * @var $dataProvider ArrayDataProvider
 */

use frontend\models\search\AverageHistoricalPricesDishes;
use yii\data\ArrayDataProvider;
use yii\grid\GridView;

$this->title = 'My Yii Application';
?>
<div class="site-index">
    <div class="body-content">
        <div class="row">
            <div class="col-lg-12">
                <?= GridView::widget(
                    [
                        'id' => 'model-grid',
                        'dataProvider' => $dataProvider,
                        'filterOnFocusOut' => false,
                        'layout' => "{items}",
                        'options' => ['class' => false],
                        'columns' => [
                            [
                                'attribute' => 'd',
                                'header' => 'Год',
                                'enableSorting' => false,
                            ],
                            [
                                'attribute' => 'avg_price',
                                'header' => 'Средняя цена',
                                'value' => static function ($data) {
                                    return "{$data['avg_price']}  {$data['bar']}";
                                },
                                'enableSorting' => false,
                            ]
                        ]
                    ]
                ); ?>
            </div>
        </div>

    </div>
</div>
