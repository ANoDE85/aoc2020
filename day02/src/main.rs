use regex::Regex;
use std::fs::File;
use std::io::{BufRead, BufReader};


fn day02() {
    let re = Regex::new(r"^(\d+)-(\d+) (\w): (.*?)$").unwrap();
    let filename="inputs/day02.txt";
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);

    // Read the file line by line using the lines() iterator from std::io::BufRead.
    let mut num_valid_1 = 0;
    let mut num_valid_2 = 0;
    for (_, line) in reader.lines().enumerate() {
        let line = line.unwrap();
        //println!("{}", line);
        assert!(re.is_match(&line));
        let cap = re.captures(&line).unwrap();
        //println!("{}, {}, {}, {}", &cap[0], &cap[1], &cap[2], &cap[3]);
        let from = cap[1].parse::<usize>().unwrap();
        let to = cap[2].parse::<usize>().unwrap();
        let c = &cap[3];
        let pwd = &cap[4];

        let char_count = pwd.matches(c).count();
        if char_count >= from && char_count <= to {
            num_valid_1 = num_valid_1 + 1;
        }

        if (&pwd[from-1..from] == c && &pwd[to-1..to] != c) || (&pwd[from-1..from] != c && &pwd[to-1..to] == c) {
            num_valid_2 = num_valid_2 + 1;
        }
    }
    println!("Valid Lines[1]: {}", num_valid_1);
    println!("Valid Lines[2]: {}", num_valid_2);
}

fn main() {
    day02();
}
