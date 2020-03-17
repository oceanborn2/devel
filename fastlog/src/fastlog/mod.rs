pub mod fastlog {
    use std::fmt::{Display, Error, Formatter};
    use std::fmt;
    use std::ops::Deref;
    use std::u8;
    use std::vec::*;

    #[warn(dead_code)]
    pub enum LevelCode { None = 0, Info = 1, Warn = 2, Error = 4, Fatal = 8, Critical = 16, Debug = 128 }

    pub struct Logdata {
        pub id: u64,
        pub tstamp: u64,
        pub level: u8,
        //LevelCode, from bits union of LevelCode,
        pub text: &'static str,
    }

    impl LevelCode {
        pub fn from(values: Vec<LevelCode>) -> u8 {
            let mut octet: u8 = 0;
            for v in values {
                octet |= v as u8;
            }
            octet
        }
    }

    impl Display for Logdata {
        fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
            write!(f, "({}, {}, {}, {})", self.id, self.level, self.text, self.tstamp)
        }
    }
}