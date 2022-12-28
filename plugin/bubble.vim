" Bubble will fold everything above and below

fu! Fold(ln1, ln2)
    se foldmethod=manual
    exe "normal! ".a:ln1."GV".a:ln2."Gzf"
endfu

fu! Bubble(ln1, ln2)
    let l:save_pos = getpos(".")
    if !exists("b:bubble_depth")
        " have to delete existing expr folds, or Folding manual messes up
        se foldmethod=manual
        exe "normal! zE"
        let b:bubble_depth = 0
    endif
    call Fold(1,         a:ln1 - 1)
    call Fold(a:ln2 + 1, line('$'))
    let b:bubble_depth += 1
    call setpos('.', l:save_pos)
    Goyo
endfu

fu! ToggleBubble(ln1, ln2)
    let b:bubble_depth = !exists("b:bubble_depth") ? 0 : b:bubble_depth
    " not sure how to make it call func in ternary without assign
    let l:nothing = !b:bubble_depth ? Bubble(a:ln1, a:ln2) : Unbubble()
endfu

fu! Unbubble()
    if exists("b:bubble_depth") && b:bubble_depth
        Goyo
        let l:save_pos = getpos(".")
        " exe "normal! Gzdggzd"
        exe "normal! zEzz"
        let b:bubble_depth -= 1
        call setpos('.', l:save_pos)
    endif
endfu

fu! RangeBubble() range
    call Bubble(a:firstline, a:lastline)
endfu

vno gb :call RangeBubble()<CR>
nno gb :call Unbubble()<CR>
