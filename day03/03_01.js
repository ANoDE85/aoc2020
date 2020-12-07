var fs = require("fs");

function countTrees(fn, slope_y, slope_x)
{
    var lines = fs.readFileSync(fn).toString().split("\n");
    for(var idx = 0; idx < lines.length; ++idx)
    {
        lines[idx] = lines[idx].trim();
        // console.log(lines[idx]);
    }
    var current_line = 0;
    var current_col = 0;
    var trees = 0;
    while (current_line < lines.length)
    {
        if (lines[current_line][current_col] === '#')
        {
            trees += 1;
        }
        current_line += slope_y;
        current_col += slope_x;
        current_col = current_col % lines[0].length;
    }
    return trees;
}

console.log("Trees: " + countTrees('demo.txt', 1, 3));
console.log("Trees: " + countTrees('input.txt', 1, 3));

var slopes_x = [1, 3, 5, 7, 1];
var slopes_y = [1, 1, 1, 1, 2];

var product = 1;
for(var cidx = 0; cidx < slopes_x.length; ++cidx)
{
    product *= countTrees('demo.txt', slopes_y[cidx], slopes_x[cidx]);
}
console.log("Tree Product (Demo): " + product);

product = 1;
for(var cidx = 0; cidx < slopes_x.length; ++cidx)
{
    product *= countTrees('input.txt', slopes_y[cidx], slopes_x[cidx]);
}
console.log("Tree Product (input): " + product);
