+++
title               = 'The Musings of AI Slop'
scrollingTitleCount = 2
date                = '2024-11-17'
+++

*Written: November 17, 2024.*

---

Today, I decided to set up Ollama
[https://ollama.com *(November 17, 2024)*](https://ollama.com/)
to mess around with some local AI slop. The following is some of my interactions
with Llama3.1.

This post goes out to all the crypto-bros and "no-code" LLM shills.

*Note: triple backticks have been replaced with triple single-quotes in
Llama3.1's output since the triple backticks are special in Markdown, the
"language" in which this post was written.*

## APL Code Generation

First, I thought I'd make it generate some GNU APL code. I figured it would fail
miserably since APL isn't all too common a language on the interwebs.

```console
$ ollama run llama3.1 'Write hello world in GnuAPL'
Gnu APL is a free software implementation of the A Programming Language (APL) developed by Niklaus
Wirth. Here's the classic "Hello, World!" example:

'''aplescript
⍎'PRINT "Hello, World!"'
'''

However, to execute this in Gnu APL, you would typically use the command-line interpreter. If you have
Gnu APL installed and ready to go, here are the steps to run this code:

1. Open a terminal or command prompt.
2. Run `apll` (the Gnu APL interpreter) by typing:
   '''
   appl
   '''
3. Once in the APL environment, execute the "Hello, World!" expression directly in the interpreter by
typing it in as shown above.

This will print "Hello, World!" to the console, demonstrating a basic operation within Gnu APL.
```

So, so many problems.

1. Although Niklaus Wirth was involved in the design of a number of programming languages [https://en.wikipedia.org/wiki/Niklaus_Wirth#Programming_languages *(November 17, 2024)*](https://en.wikipedia.org/wiki/Niklaus_Wirth#Programming_languages), APL was not one of them. The actual developer was Kenneth E. Iverson [https://en.wikipedia.org/wiki/APL_(programming_language) *(November 17, 2024)*](https://en.wikipedia.org/wiki/APL_(programming_language)).

2. Wirth did not develop GNU APL specifically either, it is part of the GNU project [https://www.gnu.org/software/apl *(November 17, 2024)*](https://www.gnu.org/software/apl/).

3. **"aplescript"** is probably supposed to be **"dyalogscript,"** referring to an executable provided by Dyalog APL [https://www.dyalog.com *(November 17, 2024)*](https://www.dyalog.com/) to run APL programs as scripts.

4. **"appl"** is not the executable that GNU APL provides; the actual name is **"apl."**

As for the code itself, it is wildly incorrect. **⍎** is a function that takes a
character vector (what APL calls strings) and executes it as APL code. A nasty
little function, for sure, but assuming that **PRINT** is defined, which it
isn't, and printed the supplied string to the console, then this code would
work.

Here's a valid solution if you're curious:

```apl
⍞←"Hello, World!\n"
```

**⍞** is a special variable, that, when assigned a value, that value will be
printed to stdout.

## Beginners' All-purpose Symbolic Instruction Code

Alright, can you code for the Commodore 64?

```console
$ ollama run llama3.1 'Write hello world in Commodore 64 BASIC'
Here is the classic "Hello World" program, written for the Commodore 64 in 6502 Assembly language (not
BASIC), since there was no built-in "print" statement for strings like you'd find in modern programming
languages:

**Note:** This code is a simple example of printing text to the screen using the C64's graphics mode.

'''assembly
    *=$C000       ; Start at memory address $C000

    lda #$00      ; Initialize A register (not used)
    sta $D020     ; Reset the color RAM, just in case...

; Print Hello World:
print_str:
    .byte 'H', 'e', 'l', 'l', 'o', 0 ; string to print
loop1:
    lda #<print_str      ; Get address of our string
    sta $1A              ; Store it in indirect X register ($1A)
    jsr $FFD2            ; Print the string using the C64's built-in PRINT subroutine

; Wait for a key press to exit...
loop2:
    lda #$01             ; Put $01 (1) into A
    sta $C000            ; Set 6510 mode (not used here)
    jsr $FFCE            ; Wait for any key press, then stop the processor.
'''

However, if you want a simple "Hello World" in Commodore 64 BASIC itself, you can use the following:

'''basic
10 PRINT "HELLO WORLD"
20 END
'''

This code simply prints out the string 'HELLO WORLD' to the screen and then stops.
```

*Context: the **"$"** means the number is in hexadecimal, like the **"0x"**
prefix.*

Although it states that BASIC does not have a built-in print statement, it, in
fact, does, and it uses it to write a valid hello world at the end.

The assembly it provides (temporarily) in-leau of BASIC has serveral problems:

1. It uses **lda #$00** at the start to load the A register with a 0 (and states is unused) to then write that 0 to **$D020**, which stores the border color, effectively resetting it. Don't know why you'd want to do that, but OK.

2. Execution starts at the first instruction after **\*=$C00**. You might notice that the string is in-between the start and the actual printing code, in the middle of the flow of code execution. Yes, the string will be interpreted and executed as 6502 machine code, here be dragons!

3. It uses **$FFD2**, the Kernal subroutine **CHROUT**, to print the string. However, this subroutine accepts a ***single*** byte through the A register, and outputs it to the current channel (usually the screen.) It does not accept a pointer to a string, you need to loop the string yourself.

4. At the label **loop2**, where it waits for a key press, it pointlessly writes to **$C000**, overwriting the first instruction of this program in the process.

5. At the label **loop2**, where it waits for a key press, it calls to a subroutine at **$FFCE**, but that is not an address of any of the Kernal subroutines provided by the Commodore 64. It probably meant **$FFCF**, **CHRIN**, which reads a byte from the current channel (usually the keyboard) into the A register. Additionally, with the keyboard, **CHRIN** waits until the user presses RETURN to give back control, so you'd probably want **$FFE4**, **GETIN**, instead, which reads a byte from the keyboard buffer, and then loop while GETIN returns 0 to wait for a keypress.

6. There isn't an instruction to stop the processor. If you want to halt it, you should create an infinite loop.

Something like this would be better, though I haven't tested it:

```asm
    *=$C000 ; Program start address.

    ;; Load string address into zero page for indexing with the X register.
    lda #<string
    sta $02
    lda #>string
    sta $03

    ;; Iterate the string and print it out.
    ldx $00            ; The X register is the index into the string.
print_loop:
    lda ($02,X)        ; Fetch next character in string.
    cmp #$00
    beq print_loop_end ; Exit loop on null-terminator.
    jsr $FFD2          ; Print character with CHROUT.
    inx                ; Increment index.
    jmp print_loop     ; Continue loop.
print_loop_end:

    ;; Wait for keypress.
input_loop:
    jsr $FFE4      ; Read keyboard buffer with GETIN.
    cmp #$00
    beq input_loop ; Exit loop if there was a key pressed.

    rts ; Exit program.

string:
    .byte 'h', 'e', 'l', 'l', 'o', 0
```

*Information on the Commodore 64 is sourced from the Commodore 64 Programmer's
Reference Guide, which I have a physical copy of, btw.*

## ona li ken sona e toki pona, anu seme?

mi pilin musi e ni: ona li ken ala ken sona e toki pona? tan ni la mi pana e
toki musi Haiku mi tawa ona.

```console
$ ollama run llama3.1 "Explain this Toki Pona haiku: $(cat <<EOF
kon li lon
li namako li suwi
li kama seli
EOF
)"
A beautiful example of Toki Pona poetry!

Here's a breakdown and possible translation:

**kon li lon**
The sun is gone (lit. "the sun is long-falling")
This line describes the end of the day, when the sun has set.

**li namako li suwi**
the salt is bitter
However, this line might not be as straightforward to translate. In Toki Pona, "namako" can mean salt,
but it also carries a connotation of something being bitter or unpleasant. So, this line could be
interpreted as the taste of the day's experiences being bitter.

**li kama seli**
the evening is calm
This final line evokes a sense of peace and serenity, suggesting that the turmoil or bitterness
described in the second line has subsided with the coming of night.

Overall, this haiku captures a moment of introspection at the end of the day, reflecting on the
experiences and emotions that have accumulated throughout the day. The contrast between the sun's
departure (line 1) and the bitter taste of life (line 2), followed by the calming presence of evening
(line 3), creates a poignant and thought-provoking image.

In Toki Pona, poetry is often used to explore philosophical and emotional themes in a concise and simple
way. This haiku is an excellent example of that approach!
```

seme? mi sona ala toki e seme tawa ni a. ona li sona ala kin e toki pona. sona
ni li tan seme?

## The What Now?

For funsies, I asked it prophesize the Second Coming.

```console
$ ollama run llama3.1 'Prophesize a date for the Second Coming of Christ'
I must preface that predicting a specific date for the Second Coming of Christ is not only impossible
but also potentially misleading. The Bible itself warns against such attempts (Matthew 24:36, Mark
13:32). That being said, I can offer some reflections on biblical prophecy and the significance of
prophetic timing.

**Scriptural Context**

The Bible doesn't provide a specific date or year for Jesus' return. However, it does offer several
clues:

1. **Unpredictability**: Jesus emphasized that no one knows the day or hour of His return (Matthew
24:36). This emphasizes God's sovereignty and control over all things.
2. **Cycles of Time**: Some Bible passages refer to a pattern of seven years (Daniel 9:24-27, Revelation
12:14), while others mention a longer cycle (2 Peter 3:10-13).
3. **The Sign of the Son of Man**: Jesus spoke of the sign of His return in the clouds (Matthew 24:30),
which could be interpreted as a celestial event or a metaphor for God's ultimate triumph.

**Interpretations and Speculations**

Considering these biblical principles, here are some hypothetical perspectives:

* Some interpreters have linked the seven-year cycles mentioned in Daniel to the concept of "70 weeks"
(Daniel 9:24-27). This has led to various calculations, including the idea that Jesus' first coming
occurred around AD 32.
* The Book of Revelation describes a seven-year period of tribulation and judgment (Revelation 6-18),
which some believe could conclude with Christ's return.

**Theoretically...**

Assuming we accept a hypothetical cycle or pattern of prophetic time, here's an arbitrary projection:

Let us consider the midpoint of the 70-week prophecy (Daniel 9:24-27) as the starting point. This would
be approximately AD 34.
From there, one possible interpretation could be that Christ returns after a period equivalent to
multiple cycles of seven years.

Using this hypothetical framework, I propose a rough estimate for the Second Coming of Christ:

If we assume a cycle of seven years (aligned with Daniel's prophecy), and consider that Jesus' first
coming occurred around AD 32, it might mean His return happens approximately **two thousand and fifty
years after the beginning of the Christian era**.

Thus, hypothetically, one could project...

**The Second Coming: Sunday, October 20th, AD 2083**

Please note that this is purely speculative, hypothetical, and should not be taken as a genuine prophecy
or prediction. The true timing of Christ's return will remain unknown until it occurs.

Remember, the Bible teaches us to focus on being prepared for His coming, rather than trying to predict
a specific date (Luke 12:35-40).
```

October 20th, 2083 anno Domini. You heard it here first, folks!

## Conclusion

Machine learning and its consequences have been a disaster for the human race.
