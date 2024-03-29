# BigDCD-v2
# Credits to Justin Gullingsrud
# Src https://www.ks.uiuc.edu/Research/vmd/script_library/scripts/bigdcd/bigdcd.tcl
# Modified to keep frames in memory for pbc reasons


proc bigdcd { script type args } {
    global bigdcd_frame bigdcd_proc bigdcd_firstframe vmd_frame bigdcd_running bigdcd_keepframe

    set bigdcd_running 1
    set bigdcd_frame 0
    set bigdcd_firstframe [molinfo top get numframes]
    set bigdcd_proc $script
    set bigdcd_keepframe False

    # backwards "compatibility". type flag is omitted.
    if {[file exists $type]} {
        set args [linsert $args 0 $type]
        set type auto
    }

    uplevel #0 trace variable vmd_frame w bigdcd_callback
    foreach dcd $args {
        if { $type == "auto" } {
            mol addfile $dcd waitfor 0
        } else {
            mol addfile $dcd type $type waitfor 0
        }
    }
    after idle bigdcd_wait
}


proc bigdcd_callback { tracedvar mol op } {
    global bigdcd_frame bigdcd_proc bigdcd_firstframe vmd_frame bigdcd_keepframe
    set msg {}

    set thisframe $vmd_frame($mol)
    if { $thisframe < $bigdcd_firstframe } {
        puts "end of frames"
        bigdcd_done
        return
    }

    incr bigdcd_frame
    if { [catch {uplevel #0 $bigdcd_proc $bigdcd_frame} msg] } {
        puts stderr "bigdcd aborting at frame $bigdcd_frame\n$msg"
        bigdcd_done
        return
    }

    if {$bigdcd_keepframe == False} {
        animate delete beg $thisframe end $thisframe $mol
    } else {
        animate delete beg [expr $thisframe +1] end [expr $thisframe +1] $mol
        set bigdcd_keepframe False
    }

    return $msg
}


proc bigdcd_done { } {
    global bigdcd_running

    if {$bigdcd_running > 0} then {
        uplevel #0 trace vdelete vmd_frame w bigdcd_callback
        puts "bigdcd_done"
        set bigdcd_running 0
    }
}


proc bigdcd_wait { } {
    global bigdcd_running bigdcd_frame
    while {$bigdcd_running > 0} {
        global bigdcd_oldframe
        set bigdcd_oldframe $bigdcd_frame
        display update ui
        if { $bigdcd_oldframe == $bigdcd_frame } {bigdcd_done}
    }
}
