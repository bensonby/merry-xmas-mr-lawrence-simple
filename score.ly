\version "2.18.2"
\include "articulate.ly"
#(set-global-staff-size 16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  http://lsr.di.unimi.it/LSR/Item?id=445

%LSR by Jay Anderson.
%modyfied by Simon Albrecht on March 2014.
%=> http://lilypond.1069038.n5.nabble.com/LSR-445-error-td160662.html

#(define (octave-up m t)
 (let* ((octave (1- t))
      (new-note (ly:music-deep-copy m))
      (new-pitch (ly:make-pitch
        octave
        (ly:pitch-notename (ly:music-property m 'pitch))
        (ly:pitch-alteration (ly:music-property m 'pitch)))))
  (set! (ly:music-property new-note 'pitch) new-pitch)
  new-note))

#(define (octavize-chord elements t)
 (cond ((null? elements) elements)
     ((eq? (ly:music-property (car elements) 'name) 'NoteEvent)
       (cons (car elements)
             (cons (octave-up (car elements) t)
                   (octavize-chord (cdr elements) t))))
     (else (cons (car elements) (octavize-chord (cdr elements ) t)))))

#(define (octavize music t)
 (if (eq? (ly:music-property music 'name) 'EventChord)
       (ly:music-set-property! music 'elements (octavize-chord
(ly:music-property music 'elements) t)))
 music)

makeOctaves = #(define-music-function (parser location arg mus) (integer? ly:music?)
 (music-map (lambda (x) (octavize x arg)) (event-chord-wrap! mus)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cr = \change Staff = "right"
cl = \change Staff = "left"
rhMark = \markup { 
  \path #0.1 #'((moveto -1 0)(rlineto 0 -1.5)(rlineto 0.5 0))
}

\header {
  title = "Merry Christmas My Lawrence"
  subtitle = "For Violin and Piano"
  composer = "Composed by Ryuichi Sakamoto"
  arranger = "Arranged by Benson"
}

violin-a = \relative c'' {
}

upper-a = \relative c'''' {
}

lower-a = \relative c'' {
}

violin-b = \relative c'' {
}

upper-b = \relative c'' {
}

lower-b = \relative c'' {
}

violin-c = \relative c'' {
}

upper-c = \relative c'' {
}

lower-c = \relative c'' {
}

violin-d = \relative c'' {
}

upper-d = \relative c'' {
}

lower-d = \relative c'' {
}

violin-e = \relative c'' {
}

upper-e = \relative c'' {
}

lower-e = \relative c'' {
}

violin-f = \relative c'' {
}

upper-f = \relative c'' {
}

lower-f = \relative c'' {
}

violin-g = \relative c'' {
}

upper-g = \relative c'' {
}

lower-g = \relative c'' {
}

violin-h = \relative c'' {
}

upper-h = \relative c'' {
}

lower-h = \relative c'' {
}

upper = \relative c' {
  \clef treble
  \tempo 4. = 70
  \time 12/8
  \key a \minor
  \upper-a
  \upper-b
  \upper-c
  \upper-d
  \upper-e
  \upper-f
  \upper-g
  \upper-h
  \bar "|."
}

lower = \relative c {
  \clef bass
  \time 12/8
  \key a \minor
  \lower-a
  \lower-b
  \lower-c
  \lower-d
  \lower-e
  \lower-f
  \lower-g
  \lower-h
  \bar "|."
}

dynamics = {
}

violin = \relative c'' {
  \clef treble
  \time 12/8
  \key a \minor
  \violin-a
  \violin-b
  \violin-c
  \violin-d
  \violin-e
  \violin-f
  \violin-g
  \violin-h
  \bar "|."
}

\paper {
  page-breaking = #ly:page-turn-breaking
}
\score {
  <<
    \new Staff = "violinstaff" <<
      \set Staff.midiInstrument = #"violin"
      \set Staff.instrumentName = #"Vocal"
      \set Staff.midiMinimumVolume = #0.7
      \set Staff.midiMaximumVolume = #0.8
      \new Voice = "violin" {
        \violin
      }
    >>
    \new PianoStaff <<
      \set PianoStaff.instrumentName = #"Piano"
      \new Staff = "right" {
        \set Staff.midiInstrument = #"acoustic grand"
        \set Staff.midiMinimumVolume = #0.9
        \set Staff.midiMaximumVolume = #1
        \upper
      }
      \new Dynamics = "Dynamics_pf" \dynamics
      \new Staff = "left" {
        \set Staff.midiInstrument = #"acoustic grand"
        \set Staff.midiMinimumVolume = #0.9
        \set Staff.midiMaximumVolume = #1
        \lower
      }
    >>
  >>
  \layout {
    \context {
      % add the RemoveEmptyStaffContext that erases rest-only staves
      \Staff \RemoveEmptyStaves
    }
    \context {
      % add the RemoveEmptyStaffContext that erases rest-only staves
      % \Dynamics \RemoveEmptyStaves
    }
    \context {
      \Score
      % Remove all-rest staves also in the first system
      \override VerticalAxisGroup.remove-first = ##t
      % If only one non-empty staff in a system exists, still print the starting bar
      \override SystemStartBar.collapse-height = #1
    }
    \context {
      \ChordNames
      \override ChordName #'font-size = #-3
    }
  }
  \midi {
    \context {
      \ChordNameVoice \remove Note_performer
    }
  }
}

\book {
\bookOutputSuffix "no-violin"
\score {
  <<
    \new PianoStaff <<
      \set PianoStaff.instrumentName = #"Piano"
      \new Staff = "right" {
        \set Staff.midiInstrument = #"acoustic grand"
        \set Staff.midiMinimumVolume = #0.3
        \set Staff.midiMaximumVolume = #0.7
        \upper
      }
      \new Dynamics = "Dynamics_pf" \dynamics
      \new Staff = "left" {
        \set Staff.midiInstrument = #"acoustic grand"
        \set Staff.midiMinimumVolume = #0.3
        \set Staff.midiMaximumVolume = #0.7
        \lower
      }
    >>
  >>
  \midi {
    \context {
      \ChordNameVoice \remove Note_performer
    }
  }
}
}
