
#[cfg(bsearch_inf_loop)]
//region bsearch_inf_loop
fn bsearch<V>(s: &[(i32,V)], k: i32) -> Option<&(i32,V)> {
    let mut a = 0;
    let mut b = s.len() as i32;
    while b > a {               
        let mid = a + (b - a)/2;
        let curr = &s[mid as usize];
        if curr.0 == k {
            return Some(curr);
        } else if curr.0 > k {
            b = mid;
        } else {
            a = mid;
        }
        
    }
    None
}
//endregion

#[cfg(bsearch_debug_logs)]
//region bsearch_debug_logs
fn bsearch<V>(s: &[(i32,V)], k: i32) -> Option<&(i32,V)> {
    println!("haystack: {:?} needle: {k}\nA M B",
             s.iter().map(|x|x.0).collect::<Vec<_>>());
    let mut a = 0;
    let mut b = s.len() as i32;
    while b > a {               
        let mid = a + (b - a)/2;
        let curr = &s[mid as usize];
        println!("{a} {mid} {b}");
        if curr.0 == k {
            return Some(curr);
        } else if curr.0 > k {
            b = mid;
        } else {
            a = mid;
        }
        
    }
    None
}
//endregion

#[cfg(incorrect_fix)]
//region incorrect_fix
fn bsearch<V>(s: &[(i32,V)], k: i32) -> Option<&(i32,V)> {
    println!("haystack: {:?} needle: {k}\nA M B",
             s.iter().map(|x|x.0).collect::<Vec<_>>());
    let mut a = 0;
    let mut b = s.len() as i32;
    while b > a {               
        let mid = a + (b - a)/2;
        let curr = &s[mid as usize];
        println!("{a} {mid} {b}");
        if curr.0 == k {
            return Some(curr);
        } else if curr.0 > k {
            b = mid - 1; // was `b = mid;`
        } else {
            a = mid + 1; // was `a = mid;`
        }
        
    }
    None
}
//endregion

#[test]
fn demo_2() {
    //region demo_data
    let demo = vec![(1, "one"), (2, "two"), (4, "four"),
                    (5, "five"), (6, "six"), (9, "nine")];
    //endregion
    assert_eq!(
        //region demo2
        bsearch(&demo, 2)
        //endregion
            , Some(&(2, "two")));
}

#[test]
fn demo_3() {
    let demo = vec![(1, "one"), (2, "two"), (4, "four"), (5, "five"), (6, "six"), (9, "nine")];
    dbg!(
        //region demo3
        bsearch(&demo, 3)
        //endregion
    );
}


fn main() {
    let demo = vec![(1, "one"), (2, "two"), (4, "four"), (5, "five"), (6, "six"), (9, "nine")];
    dbg!(bsearch(&demo, 2));
    dbg!(bsearch(&demo, 3));
    dbg!(bsearch(&demo, 6));
}

