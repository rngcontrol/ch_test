<?php

namespace common\components\ch;

use ClickHouseDB\Client;
use yii\base\Component;
use yii\base\InvalidConfigException;

class Connection extends Component{

    public string $host;
    public string $port;
    public string $username;
    public string $pwd;
    public string $db;

    private $client;

    public function init()
    {
        parent::init();

        if(empty($this->host)){
            throw new InvalidConfigException('Без хоста никак');
        }

        if(empty($this->port)){
            throw new InvalidConfigException('Без порта никак');
        }

        if(empty($this->username)){
            throw new InvalidConfigException('Без юзера никак');
        }

        if(is_null($this->pwd)){
            throw new InvalidConfigException('Без пароля можно, но хотя бы пустая строка быть должна');
        }

        $this->setClient();

    }

    /**
     * @return Client
     */
    public function getClient(): Client
    {
        return $this->client;
    }

    /**
     * @return void
     */
    public function setClient(): void
    {
        $db = new Client([
            'host' => $this->host,
            'port' => $this->port,
            'username' => $this->username,
            'password' => $this->pwd
        ]);
        $db->database($this->db);
        $db->setTimeout(10);       // 10 seconds
        $db->setConnectTimeOut(5); // 5 seconds
        $db->ping(true); // if can`t connect throw exception

        $this->client = $db;
    }
}