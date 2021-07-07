use std::time::{Duration, SystemTime, SystemTimeError};

use crate::fastlog::LevelCode;
use crate::fastlog::LevelCode::*;
use crate::fastlog::Logdata;

mod fastlog;

//pub use crate::fastlog::*;
//fn currtime() -> Result<Duration, SystemTimeError> {}

fn main() {
    println!("fast logger system");
    //let v = Box<self::Logdata>();
    let levels = vec!(Debug, Info);
    let mut v = Box::new(Logdata {
        id: 1,
        tstamp: SystemTime::now().elapsed().unwrap(),
        levels: LevelCode::from(levels),
        text: "some text",
        group: 0,
        subgroup: 0,
    });
    println!("{}", v);
    v.id = 2;
    v.text = "another text";
    v.levels = LevelCode::from(vec!(LevelCode::Fatal));
    println!("{}", v);
}
