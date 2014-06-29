<?php

// make sure phpunit is loaded
include 'autoload.php';

$class = new reflectionclass('PHPUnit_Framework_TestCase');
$methods = $class->getMethods(ReflectionMethod::IS_PUBLIC);

foreach ($methods as $m) {
    if (strpos($m->name, 'assert') !== 0) {
        continue;
    }
    $rm = new ReflectionMethod('PHPUnit_Framework_TestCase', $m->name);
    $params = $rm->getParameters();
    $fun_p = "";
    if (!empty($params))
    {
        $comma = '';
        foreach ($params as $p) {
            if(strlen($fun_p)>64){
                $fun_p .= $comma . '..';
                break;
            }
            $fun_p .= $comma . '$' . $p->name;
            $comma = ', ';
        }
        $fun_p = "($fun_p)";
    }
    $line = sprintf("%s\t;\t%s\n",
        $m->name,
        $fun_p
    );
    file_put_contents('phpunit.dict',$line,FILE_APPEND);
    echo $line;
}
