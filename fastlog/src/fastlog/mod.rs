//pub mod fastlog {
use std::fmt::{Display, Error, Formatter};
use std::fmt;
use std::ops::Deref;
use std::u8;
use std::vec::*;

#[warn(dead_code)]
/// Levels to combine as a binary or operation
pub enum LevelCode { None = 0, Info = 1, Warn = 2, Error = 4, Fatal = 8, Critical = 16, Debug = 128 }

/// build a byte from a vector of levels
impl LevelCode {
    pub fn from(levels: Vec<LevelCode>) -> u8 {
        let mut octet: u8 = 0;
        for v in levels {
            octet |= v as u8;
        }
        octet
    }
}

pub struct Logdata {
    /// unique event identifier
    pub id: u64,

    /// event timestamp
    pub tstamp: u64,

    ///LevelCode, from bits union of LevelCode,
    pub levels: u8,

    /// event description
    pub text: &'static str,
}

impl Display for Logdata {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {}, {}, {})", self.id, self.levels, self.text, self.tstamp)
    }
}
//}