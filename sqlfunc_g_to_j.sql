drop function if exists gregorian_to_jalali;
create function gregorian_to_jalali(gregorian_date DATETIME) RETURNS VARCHAR(255)
deterministic
begin
    declare gy, gm, gd, gy2, days, jy, jm, jd int;
    set gy = year(gregorian_date);
    set gm = month(gregorian_date);
    set gd = day(gregorian_date);
    set gy2 = if(gm >2, gy + 1, gy);
    set days = 355666 + (365 * gy) + floor((gy2 + 3) / 4) - floor((gy2 + 99) / 100) + floor((gy2 + 399) / 400) + gd + elt(gm,0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 );
    set jy = -1595 + (33 * floor(days / 12053));
    set days = mod(days,12053);
    set jy = jy + 4 * floor(days / 1461);
    set days = mod(days,1461);
    if days > 365 then
        set jy = jy + floor((days - 1) / 365);
        set days = mod(days - 1, 365);
    end if;
    if days < 186 then
        set jm = 1 + floor(days / 31);
        set jd = 1 + mod(days , 31);
    else
        set jm = 7 + floor((days - 186) / 30);
        set jd = 7 + mod(days - 186 , 30);
    end if;
    return concat_ws('/', jy, jm, jd);
end;