#[macro_use]
extern crate prettytable;
use clap::Parser;
use prettytable::{Cell, Row, Table};
use reqwest::header::{HeaderMap, HeaderValue, AUTHORIZATION};
use std::process;

/*
https://www.techgeekbuzz.com/how-to-use-github-api-in-python/
*/

#[derive(Parser, Debug)]
#[clap(author = "Nilton Oliveira <jniltinho@gmail.com>", version, about, long_about = None)]
struct Args {
    /// Set User Github
    #[clap(short = 'u', long = "set-username")]
    username: String,
}

fn main() {
    let args = Args::parse();

    if !args.username.is_empty() {
        get_user(&args.username).unwrap();
    }
}

fn get_user(github_username: &str) -> Result<(), Box<dyn std::error::Error>> {
    let mut hm = HeaderMap::new();
    let hv = HeaderValue::from_static;
    hm.insert(AUTHORIZATION, hv("api_key"));

    hm.insert("User-Agent", hv("requests"));
    hm.insert("Accept", hv("application/vnd.github.v3+json"));

    let api_url = format!("https://api.github.com/users/{github_username}");

    let client = reqwest::blocking::Client::builder()
        .default_headers(hm)
        .build()?;
    let response = client.get(&api_url).send()?;

    let status: String;

    if response.status().is_success() {
        status = format!("Server success! {:?}", response.status());
    } else if response.status().is_server_error() {
        status = format!("Server error! {:?}", response.status());
    } else {
        status = format!("Server Status: {:?}", response.status());

        let error_number = &response.status().to_string()[0..3];
        if error_number == "404" {
            println!("User Not Found on GitHub :-( ---> {}", status);
        }
        process::exit(1);
    }

    let title = format!("User:{github_username} URL:{api_url}");

    let res: serde_json::Value = response.json()?;
    //println!("{:?}", res);

    let mut table = Table::new();
    table.set_titles(row![status, title]);
    for (key, value) in res.as_object().unwrap() {
        if value.is_string() {
            //println!("{} ===> {}", key.as_str(), value.as_str().unwrap());
            let value2 = &value.as_str().unwrap();
            table.add_row(Row::new(vec![Cell::new(key.as_str()), Cell::new(value2)]));
        } else {
            //println!("{} ===> {}", key.as_str(), value);
            let value2 = &value.to_string();
            table.add_row(Row::new(vec![Cell::new(key.as_str()), Cell::new(value2)]));
        }
    }

    table.printstd();

    Ok(())
}
