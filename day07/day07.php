<?php

function read_file($fn)
{
    $nodes = array();

    $lines = array();
    $linepat = "/(?P<name>[\w ]+) bags contain (?P<contents>.*)\./";
    $content_pat = "/(?P<amount>\d+) (?P<color>.*) bag[s]?/";
    $myfile = fopen($fn, "r") or die("Unable to open file!");
    while(!feof($myfile))
    {
        $line = fgets($myfile);
        preg_match($linepat, $line, $matches) or die("Could not parse line " + $line);
        $outer = $matches['name'];
        $parts = explode(", ", $matches['contents']);

        if (array_key_exists($outer, $nodes) === false)
        {
            // add a new bag
            $node = array();
            $node["name"] = $outer;
            $node["children"] = array();
            $node["parents"] = array();
            $nodes[$outer] = $node;
        }

        foreach($parts as $part)
        {
            if (strpos($part, "no other bag") === false)
            {
                // parse the bag
                preg_match($content_pat, $part, $parsed_part) or die("Could not parse part " + $part);
                $child_record = array();
                $child_record["count"] = intval($parsed_part["amount"]);
                $child_record["name"] = $parsed_part["color"];
                $nodes[$outer]["children"][] = $child_record;

                if (array_key_exists($child_record["name"], $nodes) === false)
                {
                    // add a new bag, if necessary
                    $child_node = array();
                    $child_node["name"] = $child_record["name"];
                    $child_node["children"] = array();
                    $child_node["parents"] = array();
                    $child_node["parents"][] = $outer;
                    $nodes[$child_record["name"]] = $child_node;
                }
                else
                {
                    // bag exists, add parent if not yet added
                    $found = false;
                    foreach($nodes[$child_record["name"]]["parents"] as $parent)
                    {
                        if($parent == $outer)
                        {
                            $found = true;
                            break;
                        }
                    }
                    if($found === false)
                    {
                        $nodes[$child_record["name"]]["parents"][] = $outer;
                    }
                }
            }
        }
    }
    fclose($myfile);

    return $nodes;
}

function find_parents($nodes, $color, $parents)
{
    $node = $nodes[$color];

    foreach($node["parents"] as $parent)
    {
        $parents[$parent] = 1;
        $parents = array_merge($parents, find_parents($nodes, $parent, $parents));
    }
    return $parents;
}

function count_children($nodes, $child)
{
    $bag_count = 0;
    foreach($nodes[$child]["children"] as $child_entry)
    {
        $amt = $child_entry["count"];
        $child_name = $child_entry["name"];
        $bag_count = $bag_count + $amt + ($amt * count_children($nodes, $child_name));
    }
    return $bag_count;
}

print("------------- demo.txt ---------------\n");
$nodes = read_file("demo.txt");
$parents = array();
$parents = find_parents($nodes, "shiny gold", $parents);
print("Parent Count: " . count($parents) . "\n");
print("Child Bags: " . count_children($nodes, "shiny gold") . "\n");

print("------------- demo2.txt ---------------\n");
$nodes = read_file("demo2.txt");
print("Parent Count: " . count($parents) . "\n");
print("Child Bags: " . count_children($nodes, "shiny gold") . "\n");

print("------------- data.txt ---------------\n");
$nodes = read_file("data.txt");
$parents = array();
$parents = find_parents($nodes, "shiny gold", $parents);
print("Parent Count: " . count($parents) . "\n");
print("Child Bags: " . count_children($nodes, "shiny gold") . "\n");

?>
