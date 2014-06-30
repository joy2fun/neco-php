<?php
$constants = get_defined_constants();
$constants_names = array();
foreach ($constants as $k => $v) {
    if (strpos($k, 'YAF_') === 0)
        $constants_names[] = $k;
}

$classes_names = array();
$useNamespace = (bool) ini_get("yaf.use_namespace");
$yafClassPrefix = sprintf("Yaf%s", $useNamespace ? "\\" : "_");
$classes = array_merge(get_declared_classes(), get_declared_interfaces());
foreach ($classes as $key => $value) {
    if (strncasecmp($value, $yafClassPrefix, 4)) {
        unset($classes[$key]);
    } else {
        $classes_names[] = $value;
    }
}

$functions_names = array();
foreach ($classes as $c) {
    $class = new reflectionclass($c);
    $methods = $class->getMethods(ReflectionMethod::IS_PUBLIC);
    foreach($methods as $m)
    {
        if(strpos($m->name, '__') !==0 )
           $functions_names[$m->name]=1;
    }
}
$functions_names = array_keys($functions_names);

$output = 'yaf.dict';
$lines = '';
foreach($constants_names as $c){
    $lines .= sprintf("%s\t;\t\t;\tconst\n", $c);
}
foreach($classes_names as $c){
    $lines .= sprintf("%s\t;\t\t;\t{}\n", $c);
}
foreach ($functions_names as $c) {
    $lines .= sprintf("%s\t;\t()\n", $c);
}
file_put_contents($output, $lines);
echo $lines;
