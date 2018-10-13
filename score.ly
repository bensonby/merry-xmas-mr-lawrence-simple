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
  title = "Merry Christmas Mr. Lawrence"
  subtitle = "For Violin and Piano"
  composer = "Composed by Ryuichi Sakamoto"
  arranger = "Arranged by Benson"
}

violin-a = \relative c'' {
  \mark \default
  R1.*8
  e4.~\< e8\!-> r r r4. r
  e4.~\< e8\!-> r r r4. r
  d4.~\< d8\!-> r r r4. r
  d4.~\< d8\!-> r r r4. r
  e4.~\< e8\!-> r r r4. r
  e4.~\< e8\!-> r r r4. r
  d4.~\< d8\!-> r r r4. r
  b'4.~\< b8\!-> r r r4. r
}

upper-a = \relative c''' {
  \mark \default
  \ottava #1
  \repeat unfold 2 {
    e8 d e a e d e d e a e d
    e d e g e d e d e g e d
    d c d g d c d c d g d c
    d c d g d c b a b e b a

    e'8 d e a e d e d e a e d
    e d e g e d e d e g e d
    d c d b' d, c g' d c b' d, c
    d c d b' d, c g' d c b' d, c
  }
  \ottava #0
}

lower-a = \relative c'' {
  \clef treble
  <f a c>1.
  <f g b>
  <e g b>
  <a, c e>2. <g a c>

  <f' a c>1.
  <f g b>
  <e g b>
  <a, c e>

  <f a c>1.
  <f g b>
  <e g b>
  <a c e>2. <g a c>

  <f a c>1.
  <f g b>
  <e g b>
  <a c e>2. \clef bass b,8 a g e d c
}

violin-theme = \relative c' {
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d a c2
  r4 c' b8 g e4
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d c a2~
  a2
}
upper-theme = \relative c' {
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d a c2
  r4 <e c'> <e b'>8 g e4
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d c a2~
  a2
}
upper-theme-no-end-tie = \relative c' {
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d a c2
  r4 <e c'> <e b'>8 g e4
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d c a2
}

upper-theme-to-development = \relative c' {
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d a c2
  r4 <e c'> <e b'>8 g e4
  d8 e d a d2
  r4 d8 e d e g e
  d8 e d c <a fis>4. c8
  <a f>4. g8 <g b,>4 <e b>8 d
}

upper-theme-add-harmony = \relative c' {
  <d a>8 e d a <d a>2~
  q4 <d b>8 e <d b> e g e
  d8 e d a <c g>2~
  q4 <e c'> <e b'>8 g e4
  <d a>8 e d a <d a>2~
  q4 <d b>8 e <d b> e g e
  d8 e d c <a c,>2~
  q2
}

upper-theme-add-harmony-no-end-tie = \relative c' {
  <d a>8 e d a <d a>2~
  q4 <d b>8 e <d b> e g e
  d8 e d a <c g>2~
  q4 <e c'> <e b'>8 g e4
  <d a>8 e d a <d a>2~
  q4 <d b>8 e <d b> e g e
  d8 e d c <a c,>2
}

upper-theme-add-harmony-to-development = \relative c' {
  <d a>8 e d a <d a>2~
  q4 <d b>8 e <d b> e g e
  d8 e d a <c g>2~
  q4 <e c'> <e b'>8 g e4
  <d a>8 e d a <d a>2~
  q4 <d b>8 e <d b> e g e
  <d g,>8 e d c <a fis>4. c8
  <a f>4. g8 <g b,>4 <e b>8 d
}

violin-b = \relative c'' {
  \tempo 4 = 102
  \time 4/4
  \mark \default
  \violin-theme
  r2
  a1 b c r4 e d b
  a1 b c R1
}

upper-b = \relative c' {
  \tempo 4 = 102
  \time 4/4
  \mark \default
  <a e'>1
  <a e'>1
  <a e'>1
  r4 <e' c'> <e b'>8 g e4
  <a, e'>1
  <a e'>1
  <a e'>1~ q2
  << { e'2 } \\ { b4 c } >>
  \transpose c c' { \upper-theme }
}

lower-b = \relative c, {
  \time 4/4
  <f c'>1
  <g f'>
  a4 e' g2
  a,4 a' g <g, d'>
  <f c'>1
  <g f'>
  a4 e' g2~
  g2 <g, b d e>

  f4 c' a'2
  g,4 d' b'2
  a,4 e' c'2
  a,4 a' g <g, d'>4
  f4 c' a'2
  g,4 d' b'2
  a,4 e' c'2~
  c1
}

violin-c = \relative c'' {
  \mark \default
  a8\( g a g~ g a4 a8~
  a8 g a g~ g a g f
  e8 d e d~ d e4 e8~
  e8 d e d~ d4\) e8\( f
  a8 g a g~ g a4 a8~
  a8 g a g~ g a g f
  e8 d e a~ a e4 e8~
  e8 d e gis~ gis2\)
}

upper-c = \relative c' {
  b4 c
  \mark \default
  <d f>2~ q8 d'4 <d a'>8~
  q1
  <a, e'>2~ q8 a'4 <a e'>8~
  q2. e8 f
  <d f>2~ q8 d'4 <d a'>8~
  q1
  \arpeggioArrowDown
  <a e d a>1\arpeggio
  <gis e d cis>\arpeggio
  \arpeggioNormal
}

lower-c = \relative c' {
  <g bes>1~
  q2~ q8 a g f
  <d f>1~
  q2. e8 f
  <g bes>1~
  q2~ q8 a g f
  <fis b,>1
  <e e,>1
}

violin-d = \relative c'' {
  \mark \default
  a1 b c r4 e d b
  a1 b c R1
  R1*4
  fis1 f?1
  e2 d g g,
}

upper-d = \relative c''' {
  \mark \default
  \ottava #1
  \transpose c c'' { \upper-theme-no-end-tie }
  \ottava #0
  d8 b c e, d b c g'
  \transpose c c' { \upper-theme-to-development }
}

lower-d = \relative c, {
  f4 c' a'2
  g,4 d' b'2
  a,4 e' c'2
  a,4 a' g <g, d'>4
  f4 c' a'2
  g,4 d' b'2
  a,4 e' c'2
  g2 <g, b d e>2\arpeggio

  <f' g a c>4 q q q
  <f g b d>4 q q q
  <e g a c>4 q q q
  <a b c e>4 q <g b c e>4 q
  <fis a d>4 q q q
  <f g b>4 q q q
  <e g c>4 q <d a'> q
  <g b>4 q <g, d'> q
}

violin-e = \relative c'' {
  \mark \default
}

upper-e = \relative c' {
  \mark \default
  <e a,>8 q q q q q q q
  <e b g>8 q q q <d b g> q q q
  q8 q q q q q q q
  q8 q q q <c a g> q <d b g> q
  <e a,>8 q q q q q q q
  <e b g>8 q q q <d b g>4-- <a e b>--
  <g e b>8 q q q q q <b g d>4--
  q8 q q q <c g e>4-- <d b e,>4--
}

lower-e = \relative c, {
  <f c'>8 q q q q q q q
  <f d'>8 q q q q q q q
  <e b'>8 q q q q q q q
  <a e'>8 q q q q q <g e'> q
  <f c'>8 q q q q q q q
  <f d'>8 q q q q q q q
  <e d'>8 q q q q q q q
  <a e'>8 q q q q q <g e'> q
}

violin-f = \relative c'' {
}

upper-f = \relative c' {
  \mark \default
  \transpose c c' { \upper-theme-add-harmony }
  <b d e>4 q
}

lower-f = \relative c, {
  <f c'>8 q q q q q q q
  <g d'>8 q q q q q q q
  <a e'>8 q q q q q q q
  q8 q q q <g d'> q q q
  <f c'>8 q q q q q q q
  <g d'>8 q q q q q q q
  <a e'>8 q q q q q q q
  q8 q q q <g d'> q q q
}

violin-g = \relative c'' {
}

upper-g = \relative c''' {
  \ottava #1
  \transpose c c'' { \upper-theme-add-harmony-no-end-tie }
  \ottava #0
  d8 b c e, d b c g'
  \transpose c c' { \upper-theme-add-harmony-to-development }
}

lower-g = \relative c, {
  <f c'>8 q q q q q q q
  <g d'>8 q q q q q q q
  <a e'>8 q q q q q q q
  q8 q q q <g d'> q q q
  <f c'>8 q q q q q q q
  <g d'>8 q q q q q q q
  <a e'>8 q q q q q q q
  q8 q q q <g d'> q q q

  <f c'>8 q q q q q q q
  <g d'>8 q q q q q q q
  <a e'>8 q q q q q q q
  q8 q q q <g d'> q q q
  fis8 d' fis d fis d fis, d'
  f,8 d' f d f d f, d'
  e,8 c' e c d, a' d a
  g8 d' f d g, d' f d
}

violin-h = \relative c'' {
}

outro-theme = \relative c' {
  <a e'>2 a
  b4. d16 c b4 e,
}
upper-h = \relative c'''' {
  \outro-theme
  \transpose c c' { \outro-theme }
  \transpose c c'' { \outro-theme }
  \ottava #1
  <a c e>1\fermata
  <a c e>1\fermata
}

lower-h = \relative c, {
  \repeat unfold 6 {
    \repeat tremolo 8 { f16 c' }
  }
  \repeat tremolo 8 { f,16 c' }
  <f, c'>1\fermata
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
  \repeat volta 2 {
    \upper-f
  }
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
  \repeat volta 2 {
    \lower-f
  }
  \lower-g
  \lower-h
  \bar "|."
}

dynamics = {
}

violin = \relative c'' {
  \tempo 4. = 70
  \clef treble
  \time 12/8
  \key a \minor
  \violin-a
  \violin-b
  \violin-c
  \violin-d
  \violin-e
  \repeat volta 2 {
    \violin-f
  }
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
      \set Staff.instrumentName = #"Violin"
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

\book {
\bookOutputSuffix "violin"
\score {
  <<
    \new Staff = "violinstaff" <<
      \set Staff.midiInstrument = #"violin"
      \set Staff.instrumentName = #"Violin"
      \set Staff.midiMinimumVolume = #0.7
      \set Staff.midiMaximumVolume = #0.8
      \new Voice = "violin" {
        \violin
      }
    >>
  >>
  \layout {
  }
}
}
