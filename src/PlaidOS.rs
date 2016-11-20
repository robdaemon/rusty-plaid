#![feature(lang_items,asm)]
#![crate_type = "staticlib"]
#![no_std]

#[no_mangle]
pub extern fn rust_main() {
    let x = Some(32);
    
    // println!("Hello, world!");
}

#[lang = "panic_fmt"]
extern fn panic_fmt() {}