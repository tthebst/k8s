<?php

$CONFIG = array (
'objectstore' => array(
        'class' => '\\OC\\Files\\ObjectStore\\S3',
        'arguments' => array(
                'bucket' => 'nextcloud',
                'autocreate' => true,
                'key'    => 'getenv("AWS_ACCESS_KEY_ID")',
                'secret' => 'getenv("AWS_SECRET_ACCESS_KEY")',
                'hostname' => 'cloud.timgretler.ch',
                'port' => 1234,
                'use_ssl' => true,
                'region' => 'optional',
                // required for some non Amazon S3 implementations
                'use_path_style'=>true
        ),
)
);
?>