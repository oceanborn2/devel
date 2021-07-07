use std::convert::{From, TryInto};
use std::fmt::{Display, Error, Formatter};
use std::fmt;
use std::ops::{Deref, RangeInclusive};
use std::time;
use std::time::{Duration, SystemTime, SystemTimeError};
use std::u8;
use std::vec::*;

//::{powf32, powif32};

#[warn(dead_code)]
/// Levels to combine as a binary or operation
pub enum LevelCode { None = 0, Info = 1, Warn = 2, Error = 4, Fatal = 8, Critical = 16, Debug = 128 }

/// build a byte from a vector of levels
impl LevelCode {
    pub fn fromLevel(level: i32) -> LevelCode {
        /*let res = match level {
            LevelCode::None => LevelCode::None,
            LevelCode::Info => LevelCode::Info,
            LevelCode::Warn => LevelCode::Warn,
            LevelCode::Error => LevelCode::Error,
            LevelCode::Fatal => LevelCode::Fatal,
            LevelCode::Critical => LevelCode::Critical,
            LevelCode::Debug => LevelCode::Debug
        };*/
        level.into()//res.into()
    }

    pub fn from(levels: Vec<LevelCode>) -> i32 {
        let mut octet: i32 = 0;
        for v in levels {
            octet |= v as i32;
        }
        octet
    }
    pub fn to(levels: i32) -> Vec<LevelCode> {
        let mut asArr: Vec<LevelCode> = Vec::new();
        let min = LevelCode::None as i32;
        let max = LevelCode::Debug as i32;
//        for bitRank in LevelCode::None..=LevelCode::Critical {
        for bitRank in min..=max {//start()..bitRank.end() as i32; //.Into<i32>.into(); //(); //Into<i32>();
            let br = bitRank.try_into();
            let mut bv = 0i32;
            match br {
                Ok(value) => bv = value,
                Err(err) => {}
                //_ =>  {} // Cannot have errors in this case r = br.into_ok(); //unwrap();
            }
            let bval: i32 = 2^bv;
            println!("bval:{}", bval);
            if let bitisset = bval & levels == bval {
                let vlc: LevelCode = LevelCode::fromLevel(bval);
                asArr.push(vlc);
            }
        }
        asArr
    }
}


impl Copy for LevelCode {}

impl Clone for LevelCode {
    fn clone(&self) -> Self {
        unimplemented!()
    }
}

impl From<LevelCode> for i32 {
    fn from(level: LevelCode) -> i32 {
        return level as i32;
    }
}

impl From<i32> for LevelCode {
    fn from(level: i32) -> LevelCode {
        return *&level;
    }
}

pub struct Logdata {
    /// unique event identifier
    pub id: u64,

    /// event timestamp
    pub tstamp: Duration, //Result<Duration, SystemTimeError>,

    ///LevelCode, from bits union of LevelCode,
    pub levels: i32,

    /// main group
    pub group: u8,

    /// subgroup value
    pub subgroup: u16,

    /// event description
    pub text: &'static str,
}

impl Display for Logdata {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "(id:{} lev:{} group:{} sub:{} tsp:{} txt:{})", self.id, self.levels, self.group, self.subgroup, self.tstamp, self.text)
    }
}