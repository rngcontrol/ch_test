<?php
namespace frontend\models\search;

use yii\base\Model;
use yii\data\ArrayDataProvider;
use Yii;

class AverageHistoricalPricesDishes extends Model
{


    public function search()
    {
        $connector = Yii::$app->get('cHouse');
        $db = $connector->getClient();

        $q = <<<SQL
SELECT
    round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) AS d,
    round(avg(price), 2) as avg_price,
    bar(avg(price), 0, 100, 100) as bar
FROM menu_item_denorm
WHERE (menu_currency = 'Dollars') AND (d >= 1900) AND (d < 2022)
GROUP BY d
ORDER BY d ASC;
SQL;
        $statement = $db->select($q);

        return new ArrayDataProvider([
            'allModels' => $statement->rows(),
            'sort' => [
                'attributes' => ['d'],
            ],
            'pagination' => [
                'pageSize' => 100,
            ],
        ]);
    }
}