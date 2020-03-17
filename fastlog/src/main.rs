use crate::fastlog::fastlog::LevelCode;

mod fastlog;

//pub use crate::fastlog::*;

fn main() {
    println!("fast logger system");
    //let v = Box<self::Logdata>();
    let levels = vec!(LevelCode::Debug, LevelCode::Info);
    let mut v = Box::new(fastlog::fastlog::Logdata {
        id: 1,
        tstamp: 0,
        level: LevelCode::from(levels),
        text: "some text",
    });
    println!("{:}", v);
    v.id =2;
    v.text = "another text";
    v.level = LevelCode::from(vec!(LevelCode::Fatal));
    println!("{:}", v);
}
