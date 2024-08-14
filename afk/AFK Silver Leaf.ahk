;####################
; Inspired by Orchrist's AFK Crucible Tabbed Out
; This whole thing is based on his code
;####################
#Requires AutoHotkey >=1.1.36 <1.2
#NoEnv
#Persistent
#SingleInstance, Force
status = 0

;; Antra's bag of tricks
    ;; PreciseSleep
        PreciseSleep(s)
        {
            DllCall("QueryPerformanceFrequency", "Int64*", QPF)
            DllCall("QueryPerformanceCounter", "Int64*", QPCB)
            While (((QPCA - QPCB) / QPF * 1000) < s)
                DllCall("QueryPerformanceCounter", "Int64*", QPCA)
            return ((QPCA - QPCB) / QPF * 1000) 
        }

    ;; ViGE Wrapper DLL Creation
        if FileExist(A_Temp "\vigemwrapper.dll") {
        } else
        {
        ; ok, this requires some explaining.
        ; so far the biggest issue i've encountered with people is the fucking up of the vigemwrapper - 
        ; its location, its size, its name, it becoming corrupted by extracting from a zip.
        ; thus i present to you, the "ultimate solution" that is very stupid but ultra consistent - 
        ; build the file from base64 and place it in a place where the average user can't tamper with it. lol.
        ; also, sometimes the download from github would just corrupt? has happened to like 5 people, real strange
        ; i thought corrupt downloads were a thing of the past but i guess not with this apparently ultra fragile file
            wrapperbase64 := "
            ( LTrim Join
            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
            )"
            wrapperbase64 .= "
            ( LTrim Join
            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
            lvUEWlfX+mlhVXfUSktRidVaUlph6lZgNq2sWdWtBYu/ziz+mq3TJWj98Y/CfwFfKN4v4iDDZCwEnfbyOTBpPuh1Br8n4p9n8H4w
            HdZLL7zfL4C5CTCp152hGXZqBqhb5wUzLII9PMDme8FWAGx7hv/5js+v97cs/r96f5sqyDdZbbVZlVkmi9VcsxoOdpWlppzq8ppc
            UGxCMtzl+mrbSnchKHx5SanJQgrcpdNM1syqEosFMCzAmSoveLdKWSZrSWUV4OTrC+YaM4w51HCSoQIeryazphoIqSJvkEyzCSZN
            dmWVaR55lc/pV4GthdqlQmg6t8Ri1ZvN6NB2E8msqrGYDCXVZVUm8hCWzlplMleV1NaayuaYLLYqK5mhnzNTn6uLZT3OERdlVpcV
            WSqXV5dUEZswraigwlxzS1FmbW2RCRtNt1jL0tMXZMw3pC8k1q5yP6UN4qI8a10RWJObyEzWbllN0TJzTUlZKdAIFqzIWgH0lxWZ
            6iqBq7k8DuM5rF4sf0sJFNpZW5XVkH5JjJ0CkWBLrGQvnyszoT2ENZVhelqZxVqhNR2szFZNacrLL8w0xsRp2cjDSFFRZl1dtrlk
            Jc8w9IeXQIpqbWZTKRhFMgIwYHxFILOVldVouaRYp8hSaypFM1dUwarh2YFheu7XYcWrXY0eFrvD3WQKCHZOeanvupQf6e4RVgUY
            QXmNG7+oiurhFLLStBIsOezsM+fMnVmQk6f3jCeS0NWIDCArmUVHanEc1aZbKnBcyBEcCknsSheZSBqBtaGiqLyyCi04NhVJcMEu
            r1wOjCiqLjGjvMGKryJEx2pWllRVrvEUmapXVZprqvEWhJA4H4yaapQ0rAHLQB2RG6Y6U6nN2q2gH/THNKKktnL8Ssv4Wyqrx5ea
            rePNtmpr5UrT+KqY8THj2TC7YVSYSmq9i8mbojnWqsySWivQjnMI/fGcRFhuTc1NttpsW3UpsloPswvk8yGWFFaarbaSqrnV0Cic
            p/eJ51YzwZZ5JJNNmUOIRQwzutfiQTjfMm1mM3DCaK4B02Ah94gL3NrjBpGNATkWPlNjzob5DLQazSYLMjBHNNtmMq82gpmoMa8s
            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
            )"
            wrapperbase64 .= "
            ( LTrim Join
            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
            0ubS9uV1+/ZtKDq0wTjtg28ffLiv7p1lp4b7Xsqrifq473ffDqhZs86Z/1JBzOnTrxetOlfQfUnICk3QjdKlL0y7/HvwC7dG7Ll0
            Z/T1uJn2Lsc3qIb2eervs9LDj2bMHfOGX2Dky9EXfT7qtOFR/z7Z+3W3fdr22ZT31I2z8yZdGV2W+tGXpzdGXp91NfXhqsF3/vGB
            X8s2fTU/7B7vd2jAzthrsXMXKW9sm+5//q5QOmVOy6ERN0vuWLvZ9lzM6da/euHrseohM8c9d/Ou7sP5bX7Imb0za9uP733z1bQ1
            i6MG1H349MFfbzctTH3j3N2iy0fvtjQOe2xD5PWoE7OvdCpV4aLlkb9lBg8N7r2hxeW3bBuf+vLYmhlDXv/s4uW27ywvCn1d+dSp
            aatGHnp/i67z2+tKR208tOgfra2FmZ9OX//bjuVzOo288PKXK/oYDxmHT2rfpnfCcv8sxfq4Lu9k2Q4v/KlH/LixowJ/fFZ8q3Lb
            tz+f2Nznu683X1vy0LUli4d8FKZbOfXi/P2Wcc8v/PKREzdtW1KfbNntrXU7/LTPXNUMH5Q9fa54qiDa+Ixj9ch8xWfL3/eLWJV8
            NeuNgVlNEh8MmvPawYSzZVVZP4S2mWvZMeIb+7ffbBtdmVblG9Ynqk+rove6Om5e2bT06Rvth1/94vbjo37t0XLe9t2zZ129fHRQ
            xLzm596eMiHmxZ/+/o/viufuafb4raHd7lzZ9O+/FY77tOePM9ffDuvw9xFfffX4xX+efa/6vext/+x996J5zLWOF87HfPbywYQJ
            3baZbkxotfa3rTentjk58KMFWZk53/zcZ+2SbVc3X0v6KX2/6o20ybcmjv7mUvTWuLnL1xV8c3fXmGahs3u2aH3y0TX2cQfyJy09
            92pU9vdzHuugvTYqbs8P2z/bunjiOws6vTblH4uWTy069eKPTVY926lu5lxNr2cfuJIR06vDpqhHo0/1arNx8yPLFW8XXl359hcr
            n9B/kjjY58q4mi++7vVmu2vjb0/Pun1C+GXl+Tzh8V+jLOaDBxbqf7+VOz+615tPZJ/vn7zyi10L28W9npGQX3WtZppjUeCR8Nxb
            /cvm+7Y9aBp0pMmGld/8svNCwbZB46pfi0iZVZe5/veNn/Z54m6T4VMc2kXzjyw5sOJS9uwmTXp9cXCLcKx97uaI0PRJb0//ftOM
            k3fSpu2+82zWt29kjn99m+2hKPsT37760vOLSn5JLGm7M6b9jE5vv2fN6znXPqHnul+3nf91hpi498kuQ9p12375ge+HDSz9qcr/
            zeab/X/dvfOMsPmref+a+a/MG4eW6g4dqvjituP25aVfZRWGjXrkwxtVZ7Wr7DPUmbu6+kzYcvnKjcXLd9n3Hpk26O8BY9punTdh
            0FMzdg3bO3y+1Z771Ad+71wban5pVE7zvMiclv9uUfJITbPL8XvL93Y9u2vvgRbjmtvTPx65y7m37YJn5p9M/Hh/1otfP9lr3uOh
            11Vn5yW+/Kn5pW0PLUif/9hXwR8+PWLarciNQeMjNgePT7owUZvT4qsF8XHjRrwS1SXq26iQHyd06w+vP/DR3NxZl9+OPpnxwrg+
            nw74fm1dwmjLne0TOpsufrov9rdme35QHh0WvuGuOXRRRf9R51YcWLxicuvlNbc+Ge6w+c3PvD5qrVC6ofjZTUsU72c1Hfto8OHo
            Vue7nRu9aeSB/et7RJp/CR5b906H/pdWPz6/0xuxh3uX7/q5zTObKkbfPv7Jlz6P3b00YvKpjz7e9dtXL7x3NTXtkTebrqsyTWw9
            vMONtbMj5iVcXlow/Kb1zUdm+y0J3XY4+NJKR8AnZX1CDnR6sZl2wyfatPDvLp8MSr+89+W2H965fDbrm6PrVvudKRjSqibNdNH/
            0JJd55587NZzCzrkdX9h4d5zDzhO6Zoc2Tn9wLWUa7r8/CGDF3VL+KLV0m5NY9YPfDl27aNxF5e0WJS/7sCyyOQxV18Ymt+j/fVj
            y3/76eXF2fsvPdfk5zsTCm5+rNbNm9r70ZpH51xXaa/XXQoUJkfGX+hX6vSbd/X3RZOjs5vEpvxDOLz5u5vt0/oV/XJ4xRhF6K1v
            OyfHHet351fdp9NvFx/8wDjt6oXYY+8pL/5rxoS0Zldv7/GbveHdqNtblz/44+0lvYepHhq94dreJTE9zv+meXzrhJR3zywafDP3
            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
            MlfWSrKzr+o5IRPqZG4wcllwhLmpuBIwCNle3s3z8O5iYbCHd+uEoV7eHQ6+rd12joAHW7vt/Bt0b+2y8wOhCE61dttphsw2bjvN
            UNTGZefnghlebOOy83OhGPa3cdl5FUq87CzzsPNfwmgPO08INi87K+GHNi7LzguPgaat1MLPQZeEKvCXOd9g4sJkrouBuGYy1z+0
            N3JtZW5IaBJysTK3BktWQ3eZ22roLVZDoswdQ9lYyJC5CygbC7ky952YLI6DR2TuqpiOXInMZSiSxRoYI3MFinTkqmROhbLx8LjM
            haBsPMyQuVEom8AnABI3DmUT4IW2rr4HwkSoY+4F2BA6TJwIn8tckG+xOAl+l7lXQhxiLZRFuepNEafDjCi3z2bCnCi3z2bC8zK3
            KuhJcSbURbnbw7VVtNuDM8En2u3BmWCQuYmhl4Qn4QGZmxvaW3wSWka7vfsUtI92e/cpSIh2e3cWPBzt9u4sSI12efeS8DRkRbu8
            21t8GoZEu7x7SXgGHo12ebe3+Ayfjih595IwG+zRLu/2FmdDTbTLu5eEOVAb7fJub3EOzI52+XO7OBc+iHb5c584H87I3BjlIfE5
            0LaTuKWh34jPQ3eZu+3zo7gIitq5PP+b+BL8s517tL4KFyROW6e8JNTBrzJ3RE/cTZlT6ohTtHd7vg6a1HN3xDoIrud8FUuhpbuk
            Yhl0rOeMitehF3M0YzZXrPTS+aaXzje9dL7lpXONl861Xjrf9tL5jpfOd7x0bvTS+a6Xzs1eOj/w0vmhl84PvXRu89K5w0vnLi+d
            H3vp3Oulc6+Xzn1eOj/10rnfS+fnXjoPeek85KXzsJfOI146/+2l85iXzuNeOo976TzhpfOkl87TXjrPeuk856XznJfO77x0fu+l
            84KXzoteOn/20vmzl85fvHT+6qXzNy+dv3vpvOGl84aXzpteOm976bzrpVMUPHUqBU+dSsFTp0rw1KkRPHX6CJ46dUI6cwtgha6/
            Qi8UyNzI8BqFv7Bd5npqlyoChLoOEnc1cJvCIHwhc7H6G4pgoaCjiwtRhgg1Mtda314ZJtTJnC04T2kUimKIewGGhD+jbCokdGIZ
            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
            )"
            wrapperbase64 .= "
            ( LTrim Join
            THB7aAVZGKmKVHGfUAIKg0WqLKHB6qNRGqwGS4TBIrsQhyk2Rb4NgiABnRRY+yrriTDULlaxT2kkBwFb+Tp5SEBLyOPkJrTKJOi1
            aBXekqJeq0U5tqbxMdSuMtSuMdSuJwM3om0qvR9OI/rA2s2BtVsDa3eo6f6onaExSX0hT6Azsbsb9RFqvkCky6gPxE6GGGr3oVo9
            e3UVWl67X0AvAuejaZIcLyfSJiEIs/DCsYnYxCoaFHhb4TCSKsruRL2G2iOG2qOG2hOinq90BE1KIl+fwNpvDbWndTR51H4fWPtT
            YO0vksVHpeQEFhW1Iv3yS++lV4u+YbfhaNYGaLU4jPRcZarg27k+KrmewpR3rWe1gvy7/Qcp3Eu+GDoUl2XZdvdbMXwalFMgRYFT
            A7XS0QUAWQJExGSn5td/HtHBFS58bEJMl5jOqEsfXC+kD2JsZt4SBlMtU73ExKVNAjRNslSMppWoqd+uTaNsuNCzODrmVVlsE+j8
            I50AGnm9CdBTgC71HwmYdq4y1Vdt4VqQt/DQYuocG9etI0J3gAECpGVJe2KTx5rdZJPWkSbcvpistIk286bPNM5aVWbCRbdU2JRU
            7TSlOHBD6oiRbIqLiesSE9cVH1TYgz9QDBAuQHCj2wXpu0pfhB+llJxbSN/0SxBgRKjHwQ4AXoeCbkEZnZvbO2j3IWXMjORtN5qX
            v3nn1BiqkdxzRKXDThsv5wheunessFR5HpI7ArdlrmN0RzT6Zjmfons2wd3+HaJN0OjfzwmedhYm2x249M6iN4z5qxkWi3S8Ff7d
            bQ2mvo0r+f/iT+BraLzPOSGxjeTTXz98FfQVoNTji26lyv/aOR/+rCugPnWf8+GK5+X++++eWQCwTrn7L5wVUiefFeL65zorZAXH
            cJLOCimX9x8UHC2L2zPz7oTOcrj3nAippEk+LcJ1doN7rW2tP3HDzOc3uM5/GMcr8zKkCC1emunUC1qbm9ArDnmF7gD+6er/2Jkm
            ufx91T8/0yQbJSO5l1a2MeY+HgEeW1r483NKujB2ZRvou7H3P6Pkr7Zdv2/Ev9l4hf+T80dWNXr2SIsGNrRo1MPuE0g6yhTF6X+E
            +/fnZ5H8J/0sgAj4ozNK/rNxDOg9bQO9jZ9B4r6ODwPFFkqUd7jlqM/G98Qf13OdXvJ/f//tv1iB40AGdPnfNuT//v43/v4fAAAA
            AAAAQlNKQgEAAQAAAAAADAAAAHY0LjAuMzAzMTkAAAAABQBsAAAAGAkAACN+AACECQAAcAsAACNTdHJpbmdzAAAAAPQUAADwAAAA
            I1VTAOQVAAAQAAAAI0dVSUQAAAD0FQAApAQAACNCbG9iAAAAAAAAAAIAAApXHaIJCQMAAAD6ATMAFsQAAQAAAEcAAAAIAAAAFwAA
            AB0AAAAeAAAAZQAAAAIAAAAYAAAACQAAAAEAAAABAAAAAQAAAAoAAAABAAAABQAAAAEAAAACAAAAAABBBQEAAAAAAAYAXwqtBQoA
            vwqQCgYA3wJWCAYAHAMkCAYAcAIkCAoAeAc6CgoA2Qp+AA4AzgJWCAoAbgqQCgoAzQl+AAoADwp+AAoA9gh+AAoA1Qh+AAoAIQp+
            AAoAKwc6CgYAOwKtBQYA3QGtBRIAkQbZBhIAIQnZBhIAAAfZBg4A+AZWCBIAOQnZBg4AMQLoCQYAOwDfAA4ASQBWCAYAaACtBQ4A
            vwJWCAYAdwCtBQoAbAl+AAoAwwd+AAYAegStBQYA3AStBQYAqwCtBQoAZgc6CgoAywoHAAoAtQkHAAoAAAoHAAoA6ggHAAoABwc6
            CgoASwkHAAYAWwDfAAYAhQYnBgYASgs8BgYAGwI8BgYAvgWtBQYAZQatBQYAlgXEABYAggXmBQYAkAXEABYApwHmBQYA0QGtBQYA
            3geoBAYAkAmtBQYADwk8BgYAIwGoBAYAUgetBQYA7wNWCAYAXARWCAYACAMkCO8AkAgAAAYASwM8BgYA0gM8BgYAswM8BgYAQwQ8
            BgYADwQ8BgYAKAQ8BgYAYgM8BgYANwM3CAYA+gI3CAYAlgM8BgYAfQO5BAAAAAC7AAAAAAABAAEAgQEQAMQKmQcFAAEAAgABABAA
            pwCZBwUAAgAEAIMBEABvAAAABQAIAA0AAQAQAAEAmQcFAAsADQCDARAAtAAAAAUADgAUAIABEADDBs4ABQARABQAAAAAAP0KAAAF
            ABYAHgAxAIMBFwAhAI0HPQAhAPUKQQABABAFRQABAPUHSAABABQISAABAKwHSwAWAC0AfwEWADQAjgEWAFQAnAEhAI0HrQEhAPUK
            sgEBABAFRQAWAC0AfwEWADQAjgEWAFQAEQIxADMFRQAxAMABIgIxAMcIKwIxALsIKwIRABgBNAJTgNoFSwBTgM4ASwBQIAAAAACR
            GNcHEwABAFcgAAAAAJYIuwozAAEAXiAAAAAAkRjXBxMAAQBqIAAAAACGGNEHGwABAKggAAAAAIYAKwVYAAEAvyAAAAAAhgCdAmUA
            AQDQIAAAAACGAKwCdQADAOEgAAAAAIYAYwKEAAUA8SAAAAAAhgCHApMABgACIQAAAACGAOoKGwAIABchAAAAAIYA/gSsAAgAPCEA
            AAAAgQBwAXgBCQABIwAAAACGGNEHGwALADQjAAAAAIYAKwVYAAsASyMAAAAAhgCdAsIBCwBcIwAAAACGAKwC1QENAG0jAAAAAIYA
            6gobAA8AgiMAAAAAhgD+BKwADwCkIwAAAACBAHABCQIQAOAkAAAAAJEA0wQ3AhIA9CQAAAAAkQApC24CEwBcJQAAAACRAHoGjQIU
            AJAlAAAAAJEAXQXKAhYAFCYAAAAAkQBdBeICFwA0JgAAAACRAFIF+QIZAFwmAAAAAJEAdggwAxoAHCcAAAAAlgAZC3oDHQDcJwAA
            AACRGNcHEwAfACsoAAAAAJYA4wQTAB8AAAABAHYGAAACALkCAAABAKkJAAACALkCAAABAE4GAAABAHYGAAACALkCAAABACIFAAAB
            ANIGAAACAKYEAAABAHYGAAACALkCAAABAKkJAAACALkCAAABACIFAAABANIGAAACAKYEAAABAEwCAAABACwCAAABAKABAAACAPwF
            AAABACgCAAABAK0IAAACACwCAAABAJ0FAAABAMcIAAACALsIAAADABICAAABANIGAAACAKYEGQDRBxsAIQDRByQAEQDRBxsAQQDR
            BxsACQDRBxsAMQDRB04AOQDRBxsASQBmChsAUQCdAlwAUQChCWwAUQD6AHwAUQCHAooAMQDqCpoAeQDRB6AAMQBbAaYAgQDvAbcA
            kQBcAr4AoQAIBsYADABcAuQADABzCu8AoQAXBsYAFABcAuQAFABzCu8AHADKAQsBJADKAR8B6QC/BygB8QAQAS0B8QC0BS0B8QB/
            BC0BAQFYCjEB6QDmBy0B6QAFCC0BAQFTCzkBoQDKAT8BLABcAuQALABzCu8ANADKAWoBEQHRB04AGQHRBxsAIQGdArcBIQGhCcoB
            EQHqCtsBOQHRB6AAEQFbAeIBPABcAuQAPABzCu8AQQHmBy0BQQEFCC0BQQG1Bi0BRADKAWoBUQEBAlgAaQHIBUwCaQGfCFICWQEK
            AlkCYQEBAlgAAQGuCV8CYQGBBmgCeQHIAn0CeQECAYUCWQE+C6kCAQH1BK8CWQFoBbQCgQHRB7sCiQHRBxsAeQFYBsUCmQFUAhsA
            TACIBNkCeQHqBPUCAQF/ClgAAQFfCxIDAQFYChcDWQEHAR4DWQEHASgDoQGmB1QDqQEBAlgAVAANC2EDoQF6ClQDYQHRB2cDVACk
            BWwDYQEFCXQDWQEHAW4CVADRBxsATADRBxsATAAMAWwDuQG3AYQDwQHRB6AAaQGUBIsDyQHRB6wD0QHRBxsA2QHRB9kD6QHRB2cD
            8QHRB2cD+QHRB2cDAQLRB2cDCQLRB2cDEQLRB2cDGQLRB2cDIQLRBxkEKQLRB2cDMQLRB2cDOQLRB2cDDgBYAJIDDgBcAJ0DIQAL
            AB8AIQATACoALgAbAx4ELgATA/sDLgALA/sDLgADAwEELgD7AukDLgDzAvsDLgDrAvsDLgDjAvsDLgDbAukDLgDTAuADLgDLAroD
            LgDDArEDLgAjA0gELgArA1UEQAALAB8AgQAjAB8AgwALAB8AwwALAB8A4wALAB8ABAEjAB8AoQEjAB8A5AEjAB8AVACxAOkBPgJ3
            ApcC8AIBA0cDAgABAAAAvwo4AAIAAgADANcA8wABARYBTgFeAe0B/QHRAlkDBIAAAAEAAAAAAAAAAAAAAAAAmQcAAAQAAAAAAAAA
            AAAAAAEA1gAAAAAAAQAPABAAAAAAAAAAAACmCgAAAAAEAAAAAAAAAAAAAAABAEACAAAAAAQAAAAAAAAAAAAAAAoApAYAAAAABAAA
            AAAAAAAAAAAAAQCtBQAAAAAAAAAAAgAAAC8BAAAEAAMABgAFAAAAAFhiMzYwAE5lZmFyaXVzLlZpR0VtLkNsaWVudC5UYXJnZXRz
            Llhib3gzNjAAPD5wX18wADw+cF9fMQBJRW51bWVyYWJsZWAxAENhbGxTaXRlYDEAPD5wX18yAERpY3Rpb25hcnlgMgBGdW5jYDMA
            PD5vX18xNABGdW5jYDQATmVmYXJpdXMuVmlHRW0uQ2xpZW50LlRhcmdldHMuRHVhbFNob2NrNABEczQAQWN0aW9uYDUAPD5vX185
            ADxNb2R1bGU+AFN5c3RlbS5JTwBDb3N0dXJhAG1zY29ybGliAFN5c3RlbS5Db2xsZWN0aW9ucy5HZW5lcmljAFNldERQYWQAUmVh
            ZABMb2FkAEFkZABnZXRfUmVkAGlzQXR0YWNoZWQASW50ZXJsb2NrZWQAY29zdHVyYS5uZWZhcml1cy52aWdlbWNsaWVudC5kbGwu
            Y29tcHJlc3NlZABhZGRfRmVlZGJhY2tSZWNlaXZlZABPbkZlZWRiYWNrUmVjZWl2ZWQAPFZpR0VtQ2xpZW50PmtfX0JhY2tpbmdG
            aWVsZABzb3VyY2UAQ29tcHJlc3Npb25Nb2RlAEV4Y2hhbmdlAG51bGxDYWNoZQBJbnZva2UASURpc3Bvc2FibGUAUnVudGltZVR5
            cGVIYW5kbGUAR2V0VHlwZUZyb21IYW5kbGUAZ2V0X05hbWUAR2V0TmFtZQByZXF1ZXN0ZWRBc3NlbWJseU5hbWUAZnVsbG5hbWUA
            RXhwcmVzc2lvblR5cGUAU3lzdGVtLkNvcmUAY3VsdHVyZQBEaXNwb3NlAENyZWF0ZQBTZXREcGFkU3RhdGUARGVidWdnZXJCcm93
            c2FibGVTdGF0ZQBTZXRTcGVjaWFsQnV0dG9uU3RhdGUAU2V0QnV0dG9uU3RhdGUAU2V0QXhpc1N0YXRlAHN0YXRlAENhbGxTaXRl
            AFdyaXRlAER5bmFtaWNBdHRyaWJ1dGUAQ29tcGlsZXJHZW5lcmF0ZWRBdHRyaWJ1dGUAR3VpZEF0dHJpYnV0ZQBEZWJ1Z2dhYmxl
            QXR0cmlidXRlAERlYnVnZ2VyQnJvd3NhYmxlQXR0cmlidXRlAENvbVZpc2libGVBdHRyaWJ1dGUAQXNzZW1ibHlUaXRsZUF0dHJp
            YnV0ZQBBc3NlbWJseVRyYWRlbWFya0F0dHJpYnV0ZQBUYXJnZXRGcmFtZXdvcmtBdHRyaWJ1dGUAQXNzZW1ibHlGaWxlVmVyc2lv
            bkF0dHJpYnV0ZQBBc3NlbWJseUNvbmZpZ3VyYXRpb25BdHRyaWJ1dGUAQXNzZW1ibHlEZXNjcmlwdGlvbkF0dHJpYnV0ZQBDb21w
            aWxhdGlvblJlbGF4YXRpb25zQXR0cmlidXRlAEFzc2VtYmx5UHJvZHVjdEF0dHJpYnV0ZQBBc3NlbWJseUNvcHlyaWdodEF0dHJp
            YnV0ZQBBc3NlbWJseUNvbXBhbnlBdHRyaWJ1dGUAUnVudGltZUNvbXBhdGliaWxpdHlBdHRyaWJ1dGUAQnl0ZQBnZXRfQmx1ZQBU
            cnlHZXRWYWx1ZQBhZGRfQXNzZW1ibHlSZXNvbHZlAFN5c3RlbS5UaHJlYWRpbmcAU3lzdGVtLlJ1bnRpbWUuVmVyc2lvbmluZwBD
            dWx0dXJlVG9TdHJpbmcAQXR0YWNoAGdldF9MZW5ndGgARW5kc1dpdGgAU3Vic2NyaWJlRmVlZGJhY2sAX2ZlZWRiYWNrQ2FsbGJh
            Y2sAY2FsbGJhY2sAT2tDaGVjawBudWxsQ2FjaGVMb2NrAFZpR0VtV3JhcHBlci5kbGwAUmVhZFN0cmVhbQBMb2FkU3RyZWFtAEdl
            dE1hbmlmZXN0UmVzb3VyY2VTdHJlYW0ARGVmbGF0ZVN0cmVhbQBNZW1vcnlTdHJlYW0Ac3RyZWFtAHNldF9JdGVtAFN5c3RlbQBn
            ZXRfR3JlZW4AQXBwRG9tYWluAGdldF9DdXJyZW50RG9tYWluAEZvZHlWZXJzaW9uAFN5c3RlbS5JTy5Db21wcmVzc2lvbgBkZXN0
            aW5hdGlvbgBVbmFyeU9wZXJhdGlvbgBCaW5hcnlPcGVyYXRpb24AU3lzdGVtLkdsb2JhbGl6YXRpb24AU3lzdGVtLlJlZmxlY3Rp
            b24AZGlyZWN0aW9uAHNldF9Qb3NpdGlvbgBTdHJpbmdDb21wYXJpc29uAGJ0bgBDb3B5VG8AZ2V0X0N1bHR1cmVJbmZvAENTaGFy
            cEFyZ3VtZW50SW5mbwBNaWNyb3NvZnQuQ1NoYXJwAGdldF9MZWROdW1iZXIAQXNzZW1ibHlMb2FkZXIAc2VuZGVyAE1pY3Jvc29m
            dC5DU2hhcnAuUnVudGltZUJpbmRlcgBDYWxsU2l0ZUJpbmRlcgBYYm94MzYwRmVlZGJhY2tSZWNlaXZlZEV2ZW50SGFuZGxlcgBE
            dWFsU2hvY2s0RmVlZGJhY2tSZWNlaXZlZEV2ZW50SGFuZGxlcgBSZXNvbHZlRXZlbnRIYW5kbGVyAFhib3gzNjBDb250cm9sbGVy
            AER1YWxTaG9jazRDb250cm9sbGVyAF9jb250cm9sbGVyAFZpR0VtV3JhcHBlcgBFbnRlcgBfbGFzdExpZ2h0QmFyQ29sb3IAZ2V0
            X0xpZ2h0YmFyQ29sb3IALmN0b3IALmNjdG9yAE1vbml0b3IAZ2V0X0xhcmdlTW90b3IAX2xhc3RMYXJnZU1vdG9yAGdldF9TbWFs
            bE1vdG9yAF9sYXN0U21hbGxNb3RvcgBTeXN0ZW0uRGlhZ25vc3RpY3MAU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzAFN5
            c3RlbS5SdW50aW1lLkNvbXBpbGVyU2VydmljZXMAUmVhZEZyb21FbWJlZGRlZFJlc291cmNlcwBEZWJ1Z2dpbmdNb2RlcwBHZXRB
            c3NlbWJsaWVzAHJlc291cmNlTmFtZXMAc3ltYm9sTmFtZXMAYXNzZW1ibHlOYW1lcwBEdWFsU2hvY2s0RFBhZFZhbHVlcwBYYm94
            MzYwQXhlcwBEdWFsU2hvY2s0QXhlcwBnZXRfRmxhZ3MAQXNzZW1ibHlOYW1lRmxhZ3MAQ1NoYXJwQXJndW1lbnRJbmZvRmxhZ3MA
            Q1NoYXJwQmluZGVyRmxhZ3MAWGJveDM2MEZlZWRiYWNrUmVjZWl2ZWRFdmVudEFyZ3MARHVhbFNob2NrNEZlZWRiYWNrUmVjZWl2
            ZWRFdmVudEFyZ3MAUmVzb2x2ZUV2ZW50QXJncwBTZXRBeGlzAGF4aXMARXF1YWxzAFhib3gzNjBSZXBvcnRFeHRlbnNpb25zAER1
            YWxTaG9jazRSZXBvcnRFeHRlbnNpb25zAFN5c3RlbS5MaW5xLkV4cHJlc3Npb25zAFhib3gzNjBCdXR0b25zAER1YWxTaG9jazRC
            dXR0b25zAER1YWxTaG9jazRTcGVjaWFsQnV0dG9ucwBOZWZhcml1cy5WaUdFbS5DbGllbnQuVGFyZ2V0cwBGb3JtYXQAT2JqZWN0
            AENvbm5lY3QAVmlHRW1UYXJnZXQARXhpdABUb0xvd2VySW52YXJpYW50AE5lZmFyaXVzLlZpR0VtLkNsaWVudABOZWZhcml1cy5W
            aUdFbUNsaWVudABnZXRfVmlHRW1DbGllbnQAWGJveDM2MFJlcG9ydABEdWFsU2hvY2s0UmVwb3J0AFNlbmRSZXBvcnQAX3JlcG9y
            dABQcm9jZXNzZWRCeUZvZHkAQ29udGFpbnNLZXkAUmVzb2x2ZUFzc2VtYmx5AFJlYWRFeGlzdGluZ0Fzc2VtYmx5AEdldEV4ZWN1
            dGluZ0Fzc2VtYmx5AG9wX0VxdWFsaXR5AElzTnVsbE9yRW1wdHkAAAAAABEwAHgAMAAwADAAMAAwADAAAAVPAEsAACkwAHgAewAw
            ADoAWAAyAH0AewAxADoAWAAyAH0AewAyADoAWAAyAH0AAAEAFy4AYwBvAG0AcAByAGUAcwBzAGUAZAAAD3sAMAB9AC4AewAxAH0A
            ACluAGUAZgBhAHIAaQB1AHMALgB2AGkAZwBlAG0AYwBsAGkAZQBuAHQAAFdjAG8AcwB0AHUAcgBhAC4AbgBlAGYAYQByAGkAdQBz
            AC4AdgBpAGcAZQBtAGMAbABpAGUAbgB0AC4AZABsAGwALgBjAG8AbQBwAHIAZQBzAHMAZQBkAAAAZQajJ5Nh2E2MqbftB5+FjwAI
            t3pcVhk04IkIsD9ffxHVCjoDAAABAwYSCQMgAAEEAQAAAAUgAQERFQgBAAAAAAAAAAQAABIJBAgAEgkDBhIZAwYSHQIGHAIGBQIG
            DgUgAQESCQMHAQ4DIAAOCAADARIdES0CBiACAREtAggAAwESHRExBQYgAgERMQUHAAIBEh0RNQUgAQERNQgAAwESHRE5AgYgAgER
            OQIFIAEBEh0FIAIBHBgFIAEBEj0EIAEBHAUHAw4CAgYAARJBEUUHAAISSRFNDhAABBJVEVkRXRJBFRJhARJJDBUSZQEVEmkDEm0c
            AgoAARUSZQETABJVAwYTAA0VEmUBFRJxBBJtHBwcCRUScQQSbRwcHAogAxMDEwATARMCCBUSaQMSbRwCCCACEwITABMBBCAAEnkD
            IAAFBwAEDg4cHBwFAAICDg4OAAMSVRFZEkEVEmEBEkkPFRJlARUSgIUFEm0cBQUOCxUSgIUFEm0cBQUODSAFARMAEwETAhMDEwQG
            IAIBHBJ1DgYVEmUBFRJxBBJtHBwcDQYVEmUBFRJpAxJtHAIQBhUSZQEVEoCFBRJtHAUFDgQGEoCJBAYSgI0KAAMBEoCNEYCVAgcg
            AgERgJUCCgADARKAjRGAmQYFIAIBBwYGIAEBEoCNBiABARKAnQMHAQIPFRJlARUSgIUFEm0cBQUFCxUSgIUFEm0cBQUFByACARwS
            gKEQBhUSZQEVEoCFBRJtHAUFBQgGFRKApQIOAggGFRKApQIODgIGCAYAAQ4SgKkNBwQdEoCtCBKArRKAsQUAABKAtQYgAB0SgK0F
            IAASgLEIAAMCDg4RgLkFIAASgKkIAAESgK0SgLEFBwIdBQgHIAMBHQUICAcgAwgdBQgICQACARKAvRKAvREHBRKArRKAvRKAwRKA
            xRKAvQUAABKArQQgAQIOBiABEoC9DgkgAgESgL0RgMkEIAEBCgYAARKAvQ4HFRKApQIODgggAgITABATAQ0AAhKAvRUSgKUCDg4O
            BAcBHQUDIAAKBwABHQUSgL0QBwYOHQUSgL0SgK0SgL0dBQQAAQIOBgADDg4cHAkAAhKArR0FHQUHAAESgK0dBRYAAxKArRUSgKUC
            Dg4VEoClAg4OEoCxDAcEEoCxEoCtHBKArQQAAQEcBxUSgKUCDgIFIAECEwAEIAEBDgcgAgETABMBBSAAEYDZCQACEoCtHBKA1QYA
            AggQCAgGIAEBEoDhCjIALgAyAC4AMAAOMQAuADYALgAyAC4AMAAEIAEBCAgBAAgAAAAAAB4BAAEAVAIWV3JhcE5vbkV4Y2VwdGlv
            blRocm93cwEGIAEBEYDxCAEABwEAAAAAEQEADFZpR0VtV3JhcHBlcgAABQEAAAAAFwEAEkNvcHlyaWdodCDCqSAgMjAxOQAABCAB
            AQIpAQAkYTMzODhiNTUtZjRlOS00YTNiLTk1ZTAtYmYzNjk0MDQyMWViAAAMAQAHMS4wLjAuMAAATQEAHC5ORVRGcmFtZXdvcmss
            VmVyc2lvbj12NC43LjIBAFQOFEZyYW1ld29ya0Rpc3BsYXlOYW1lFC5ORVQgRnJhbWV3b3JrIDQuNy4yAAAAAAARc+eYAAAAAAIA
            AAB3AAAApMEAAKSjAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAbpAAAUlNEU7MY8P9RrIREhdrYVvuH0rwBAAAARDpcRGF0YVxD
            b2RlXEdpdEh1YlxNaW5lXEFISy1WaUdFbS1CdXNcQyNcVmlHRW1XcmFwcGVyXFZpR0VtV3JhcHBlclxvYmpcRGVidWdcVmlHRW1X
            cmFwcGVyLnBkYgAARMIAAAAAAAAAAAAAXsIAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFDCAAAAAAAAAAAAAAAAX0NvckRsbE1h
            aW4AbXNjb3JlZS5kbGwAAAAAAP8lACBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAQAAAAGAAAgAAAAAAA
            AAAAAAAAAAAAAQABAAAAMAAAgAAAAAAAAAAAAAAAAAAAAQAAAAAASAAAAFjgAAA8AwAAAAAAAAAAAAA8AzQAAABWAFMAXwBWAEUA
            UgBTAEkATwBOAF8ASQBOAEYATwAAAAAAvQTv/gAAAQAAAAEAAAAAAAAAAQAAAAAAPwAAAAAAAAAEAAAAAgAAAAAAAAAAAAAAAAAA
            AEQAAAABAFYAYQByAEYAaQBsAGUASQBuAGYAbwAAAAAAJAAEAAAAVAByAGEAbgBzAGwAYQB0AGkAbwBuAAAAAAAAALAEnAIAAAEA
            UwB0AHIAaQBuAGcARgBpAGwAZQBJAG4AZgBvAAAAeAIAAAEAMAAwADAAMAAwADQAYgAwAAAAGgABAAEAQwBvAG0AbQBlAG4AdABz
            AAAAAAAAACIAAQABAEMAbwBtAHAAYQBuAHkATgBhAG0AZQAAAAAAAAAAAEIADQABAEYAaQBsAGUARABlAHMAYwByAGkAcAB0AGkA
            bwBuAAAAAABWAGkARwBFAG0AVwByAGEAcABwAGUAcgAAAAAAMAAIAAEARgBpAGwAZQBWAGUAcgBzAGkAbwBuAAAAAAAxAC4AMAAu
            ADAALgAwAAAAQgARAAEASQBuAHQAZQByAG4AYQBsAE4AYQBtAGUAAABWAGkARwBFAG0AVwByAGEAcABwAGUAcgAuAGQAbABsAAAA
            AABIABIAAQBMAGUAZwBhAGwAQwBvAHAAeQByAGkAZwBoAHQAAABDAG8AcAB5AHIAaQBnAGgAdAAgAKkAIAAgADIAMAAxADkAAAAq
            AAEAAQBMAGUAZwBhAGwAVAByAGEAZABlAG0AYQByAGsAcwAAAAAAAAAAAEoAEQABAE8AcgBpAGcAaQBuAGEAbABGAGkAbABlAG4A
            YQBtAGUAAABWAGkARwBFAG0AVwByAGEAcABwAGUAcgAuAGQAbABsAAAAAAA6AA0AAQBQAHIAbwBkAHUAYwB0AE4AYQBtAGUAAAAA
            AFYAaQBHAEUAbQBXAHIAYQBwAHAAZQByAAAAAAA0AAgAAQBQAHIAbwBkAHUAYwB0AFYAZQByAHMAaQBvAG4AAAAxAC4AMAAuADAA
            LgAwAAAAOAAIAAEAQQBzAHMAZQBtAGIAbAB5ACAAVgBlAHIAcwBpAG8AbgAAADEALgAwAC4AMAAuADAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAADAAAAHAyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAA==
            )"

            wrapper := Base64Dec( wrapperbase64, jeff )

            Base64Dec( ByRef B64, ByRef Bin ) {  ; By SKAN / 18-Aug-2017
            Local Rqd := 0, BLen := StrLen(B64)                 ; CRYPT_STRING_BASE64 := 0x1
            DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
                    , "UInt",0, "UIntP",Rqd, "Int",0, "Int",0 )
            VarSetCapacity( Bin, 128 ), VarSetCapacity( Bin, 0 ),  VarSetCapacity( Bin, Rqd, 0 )
            DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
                    , "Ptr",&Bin, "UIntP",Rqd, "Int",0, "Int",0 )
            Return Rqd
            }

            File := FileOpen(A_Temp "\vigemwrapper.dll", "w")
            File.RawWrite(jeff, wrapper)
            File.Close()
        }

    ;; .Net framework shit
        ; ==========================================================
        ;                  .NET Framework Interop
        ;      https://autohotkey.com/boards/viewtopic.php?t=4633
        ; ==========================================================
        ;
        ;   Author:     Lexikos
        ;   Version:    1.2
        ;   Requires:   AutoHotkey_L v1.0.96+
        ;   EDITED by Antra, this is not the original - do not reuse expecting that to be the case.
        ;
            CLR_LoadLibrary(AssemblyName, AppDomain=0){
                if !AppDomain
                    AppDomain := CLR_GetDefaultDomain()
                e := ComObjError(0)
                Loop 1 {
                    if assembly := AppDomain.Load_2(AssemblyName)
                        break
                    static null := ComObject(13,0)
                    args := ComObjArray(0xC, 1),  args[0] := AssemblyName
                    typeofAssembly := AppDomain.GetType().Assembly.GetType()
                    if assembly := typeofAssembly.InvokeMember_3("LoadWithPartialName", 0x158, null, null, args)
                        break
                    if assembly := typeofAssembly.InvokeMember_3("LoadFrom", 0x158, null, null, args)
                        break
                }
                ComObjError(e)
                return assembly
            }

            CLR_CreateObject(Assembly, TypeName, Args*){
                if !(argCount := Args.MaxIndex())
                    return Assembly.CreateInstance_2(TypeName, true)
                
                vargs := ComObjArray(0xC, argCount)
                Loop % argCount
                    vargs[A_Index-1] := Args[A_Index]
                
                static Array_Empty := ComObjArray(0xC,0), null := ComObject(13,0)
                
                return Assembly.CreateInstance_3(TypeName, true, 0, null, vargs, null, Array_Empty)
            }

            CLR_CompileC#(Code, References="", AppDomain=0, FileName="", CompilerOptions=""){
                return CLR_CompileAssembly(Code, References, "System", "Microsoft.CSharp.CSharpCodeProvider", AppDomain, FileName, CompilerOptions)
            }

            CLR_CompileVB(Code, References="", AppDomain=0, FileName="", CompilerOptions=""){
                return CLR_CompileAssembly(Code, References, "System", "Microsoft.VisualBasic.VBCodeProvider", AppDomain, FileName, CompilerOptions)
            }

            CLR_StartDomain(ByRef AppDomain, BaseDirectory=""){
                static null := ComObject(13,0)
                args := ComObjArray(0xC, 5), args[0] := "", args[2] := BaseDirectory, args[4] := ComObject(0xB,false)
                AppDomain := CLR_GetDefaultDomain().GetType().InvokeMember_3("CreateDomain", 0x158, null, null, args)
                return A_LastError >= 0
            }

            CLR_StopDomain(ByRef AppDomain){    
                DllCall("SetLastError", "uint", hr := DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+20*A_PtrSize), "ptr", RtHst, "ptr", ComObjValue(AppDomain))), AppDomain := ""
                return hr >= 0
            }

            CLR_Start(Version="") {
                static RtHst := 0
                if RtHst
                    return RtHst
                EnvGet SystemRoot, SystemRoot
                if Version =
                    Loop % SystemRoot "\Microsoft.NET\Framework" (A_PtrSize=8?"64":"") "\*", 2
                        if (FileExist(A_LoopFileFullPath "\mscorlib.dll") && A_LoopFileName > Version)
                            Version := A_LoopFileName
                if DllCall("mscoree\CorBindToRuntimeEx", "wstr", Version, "ptr", 0, "uint", 0
                , "ptr", CLR_GUID(CLSID_CorRuntimeHost, "{CB2F6723-AB3A-11D2-9C40-00C04FA30A3E}")
                , "ptr", CLR_GUID(IID_ICorRuntimeHost,  "{CB2F6722-AB3A-11D2-9C40-00C04FA30A3E}")
                , "ptr*", RtHst) >= 0
                    DllCall(NumGet(NumGet(RtHst+0)+10*A_PtrSize), "ptr", RtHst) ; Start
                return RtHst
            }

            CLR_GetDefaultDomain(){
                static defaultDomain := 0
                if !defaultDomain
                {
                    if DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+13*A_PtrSize), "ptr", RtHst, "ptr*", p:=0) >= 0
                        defaultDomain := ComObject(p), ObjRelease(p)
                }
                return defaultDomain
            }

            CLR_CompileAssembly(Code, References, ProviderAssembly, ProviderType, AppDomain=0, FileName="", CompilerOptions=""){
                if !AppDomain
                    AppDomain := CLR_GetDefaultDomain()
                
                if !(asmProvider := CLR_LoadLibrary(ProviderAssembly, AppDomain))
                || !(codeProvider := asmProvider.CreateInstance(ProviderType))
                || !(codeCompiler := codeProvider.CreateCompiler())
                    return 0

                if !(asmSystem := (ProviderAssembly="System") ? asmProvider : CLR_LoadLibrary("System", AppDomain))
                    return 0
                
                StringSplit, Refs, References, |, %A_Space%%A_Tab%
                aRefs := ComObjArray(8, Refs0)
                Loop % Refs0
                    aRefs[A_Index-1] := Refs%A_Index%
                
                prms := CLR_CreateObject(asmSystem, "System.CodeDom.Compiler.CompilerParameters", aRefs)
                , prms.OutputAssembly          := FileName
                , prms.GenerateInMemory        := FileName=""
                , prms.GenerateExecutable      := SubStr(FileName,-3)=".exe"
                , prms.CompilerOptions         := CompilerOptions
                , prms.IncludeDebugInformation := true
                
                compilerRes := codeCompiler.CompileAssemblyFromSource(prms, Code)
                
                if error_count := (errors := compilerRes.Errors).Count
                {
                    error_text := ""
                    Loop % error_count
                        error_text .= ((e := errors.Item[A_Index-1]).IsWarning ? "Warning " : "Error ") . e.ErrorNumber " on line " e.Line ": " e.ErrorText "`n`n"
                    MsgBox, 16, Compilation Failed, %error_text%
                    return 0
                }
                return compilerRes[FileName="" ? "CompiledAssembly" : "PathToAssembly"]
            }

            CLR_GUID(ByRef GUID, sGUID){
                VarSetCapacity(GUID, 16, 0)
                return DllCall("ole32\CLSIDFromString", "wstr", sGUID, "ptr", &GUID) >= 0 ? &GUID : ""
            }

    ;; ViGEm Bus Setup
        ; ==========================================================
        ;                     AHK-ViGEm-Bus
        ;          https://github.com/evilC/AHK-ViGEm-Bus
        ; ==========================================================
        ;
        ;   Author:     evilC
        ;   EDITED by Antra, this is not the original script - do not reuse expecting that to be the case.
        ;
        class ViGEmWrapper {
            static asm := 0
            static client := 0

            Init(){
                if (this.client == 0){
                    this.asm := CLR_LoadLibrary(A_Temp "\vigemwrapper.dll")
                }
            }
            
            CreateInstance(cls){
                try {
                    return this.asm.CreateInstance(cls)
                } catch Error {
                    wrapperdownload := A_Temp . "\ViGEmBus_1.21.442_x64_x86_arm64.exe"
                    MsgBox,0x40,Exotic Class Farm Script, You do not have ViGEm installed! Press OK to continue with downloading and installing ViGEm!
                    UrlDownloadToFile, https://github.com/Antraless/tabbed-out-fishing/raw/main/ViGEmBus_1.21.442_x64_x86_arm64.exe, %wrapperdownload%
                    MsgBox,3,Exotic Class Farm Script,The ViGEm installer has been downloaded to %A_temp%.`n`nPress Yes to run the installer as admin!  Press No if you need help!`n`nPress Cancel or close the window to open the directory with the downloaded installer!
                    IfMsgBox, Yes
                    {
                        Run *Runas explorer.exe %wrapperdownload%
                        exitapp
                    }
                    IfMsgBox, No
                    {
                        Run, https://thrallway.com/
                        exitapp
                    }
                    else
                    {
                        Run, explorer.exe %A_Temp%
                        exitapp
                    }
                }
            }
        }

        ; Base class for ViGEm "Targets" (Controller types - eg xb360 / ds4) to inherit from
        class ViGEmTarget {
            target := 0
            helperClass := ""
            controllerClass := ""

            __New(){
                ViGEmWrapper.Init()
                this.Instance := ViGEmWrapper.CreateInstance(this.helperClass)
                
                if (this.Instance.OkCheck() != "OK"){
                    msgbox,4,Exotic Class Farm Script, The .dll failed to load!`n`nPlease visit the #support channel in our discord for help resolving this.`n`nPress yes to launch our discord server for help!
                    IfMsgBox, Yes
                    {
                        Run, https://thrallway.com/
                        exitapp
                    }
                    else
                    {
                        exitapp
                    }       
                    }
            }
            
            SendReport(){
                this.Instance.SendReport()
            }
            
            SubscribeFeedback(callback){
                this.Instance.SubscribeFeedback(callback)
            }
        }

        ; Xb360
        class ViGEmXb360 extends ViGEmTarget {
            helperClass := "ViGEmWrapper.Xb360"
            __New(){
                static buttons := {A: 4096, B: 8192, X: 16384, Y: 32768, LB: 256, RB: 512, LS: 64, RS: 128, Back: 32, Start: 16, Xbox: 1024}
                static axes := {LX: 2, LY: 3, RX: 4, RY: 5, LT: 0, RT: 1}
                
                this.Buttons := {}
                for name, id in buttons {
                    this.Buttons[name] := new this._ButtonHelper(this, id)
                }
                
                this.Axes := {}
                for name, id in axes {
                    this.Axes[name] := new this._AxisHelper(this, id)
                }
                
                this.Dpad := new this._DpadHelper(this)
                
                base.__New()
            }
            
            class _ButtonHelper {
                __New(parent, id){
                    this._Parent := parent
                    this._Id := id
                }
                
                SetState(state){
                    this._Parent.Instance.SetButtonState(this._Id, state)
                    this._Parent.Instance.SendReport()
                    return this._Parent
                }
            }
            
            class _AxisHelper {
                __New(parent, id){
                    this._Parent := parent
                    this._id := id
                }
                
                SetState(state){
                    this._Parent.Instance.SetAxisState(this._Id, this.ConvertAxis(state))
                    this._Parent.Instance.SendReport()
                }
                
                ConvertAxis(state){
                    value := round((state * 655.36) - 32768)
                    if (value == 32768)
                        return 32767
                    return value
                }
            }
            
            class _DpadHelper {
                _DpadStates := {1:0, 8:0, 2:0, 4:0} ; Up, Right, Down, Left
                __New(parent){
                    this._Parent := parent
                }
                
                SetState(state){
                    static dpadDirections := { None: {1:0, 8:0, 2:0, 4:0}
                        , Up: {1:1, 8:0, 2:0, 4:0}
                        , UpRight: {1:1, 8:1, 2:0, 4:0}
                        , Right: {1:0, 8:1, 2:0, 4:0}
                        , DownRight: {1:0, 8:1, 2:1, 4:0}
                        , Down: {1:0, 8:0, 2:1, 4:0}
                        , DownLeft: {1:0, 8:0, 2:1, 4:1}
                        , Left: {1:0, 8:0, 2:0, 4:1}
                        , UpLeft: {1:1, 8:0, 2:0, 4:1}}
                    newStates := dpadDirections[state]
                    for id, newState in newStates {
                        oldState := this._DpadStates[id]
                        if (oldState != newState){
                            this._DpadStates[id] := newState
                            this._Parent.Instance.SetButtonState(id, newState)
                        }
                        this._Parent.SendReport()
                    }
                }
            }
        }
    ;; Shin's Overlay Class
        ;Direct2d overlay class by Spawnova (5/27/2022)
        ;https://github.com/Spawnova/ShinsOverlayClass
        ;
        ;I'm not a professional programmer, I do this for fun, if it doesn't work for you I can try and help
        ;but I can't promise I will be able to solve the issue
        ;
        ;Special thanks to teadrinker for helping me understand some 64bit param structures! -> https://www.autohotkey.com/boards/viewtopic.php?f=76&t=105420

        class ShinsOverlayClass {

            ;x_orTitle                  :       x pos of overlay OR title of window to attach to
            ;y_orClient                 :       y pos of overlay OR attach to client instead of window (default window)
            ;width_orForeground         :       width of overlay OR overlay is only drawn when the attached window is in the foreground (default 1)
            ;height                     :       height of overlay
            ;alwaysOnTop                :       If enabled, the window will always appear over other windows
            ;vsync                      :       If enabled vsync will cause the overlay to update no more than the monitors refresh rate, useful when looping without sleeps
            ;clickThrough               :       If enabled, mouse clicks will pass through the window onto the window beneath
            ;taskBarIcon                :       If enabled, the window will have a taskbar icon
            ;guiID                      :       name of the ahk gui id for the overlay window, if 0 defaults to "ShinsOverlayClass_TICKCOUNT"
            ;
            ;notes                      :       if planning to attach to window these parameters can all be left blank
            
            __New(x_orTitle:=0,y_orClient:=1,width_orForeground:=1,height:=0,alwaysOnTop:=1,vsync:=0,clickThrough:=1,taskBarIcon:=0,guiID:=0) {
            
            
                ;[input variables] you can change these to affect the way the script behaves
                
                this.interpolationMode := 0 ;0 = nearestNeighbor, 1 = linear ;affects DrawImage() scaling 
                this.data := []             ;reserved name for general data storage
                this.HideOnStateChange := 1
            
            
                ;[output variables] you can read these to get extra info, DO NOT MODIFY THESE
                
                this.x := x_orTitle                 ;overlay x position OR title of window to attach to
                this.y := y_orClient                ;overlay y position OR attach to client area
                this.width := width_orForeground    ;overlay width OR attached overlay only drawn when window is in foreground
                this.height := height               ;overlay height
                this.x2 := x_orTitle+width_orForeground
                this.y2 := y_orClient+height
                this.attachHWND := 0                ;HWND of the attached window, 0 if not attached
                this.attachClient := 0              ;1 if using client space, 0 otherwise
                this.attachForeground := 0          ;1 if overlay is only drawn when the attached window is the active window; 0 otherwise
                
                ;Generally with windows there are invisible borders that allow
                ;the window to be resized, but it makes the window larger
                ;these values should contain the window x, y offset and width, height for actual postion and size
                this.realX := 0
                this.realY := 0
                this.realWidth := 0
                this.realHeight := 0
                this.realX2 := 0
                this.realY2 := 0
                
                this.callbacks := {"Size":0,"Position":0,"Active":0}
                ;Size       :       [this]
                ;Position:  :       [this]
                ;Active     :       [this,state]
            
                ;#############################
                ;   Setup internal stuff
                ;#############################
                this.bits := (a_ptrsize == 8)
                this.imageCache := []
                this.fonts := []
                this.lastPos := 0
                this.offX := -x_orTitle
                this.offY := -y_orClient
                this.lastCol := 0
                this.drawing := -1
                this.guiID := guiID := (guiID = 0 ? "ShinsOverlayClass_" a_tickcount : guiID)
                this.owned := 0
                this.alwaysontop := alwaysontop
                
                this._cacheImage := this.mcode("VVdWMfZTg+wMi0QkLA+vRCQoi1QkMMHgAoXAfmSLTCQki1wkIA+26gHIiUQkCGaQD7Z5A4PDBIPBBIn4D7bwD7ZB/g+vxpn3/YkEJA+2Qf0Pr8aZ9/2JRCQED7ZB/A+vxpn3/Q+2FCSIU/wPtlQkBIhT/YhD/on4iEP/OUwkCHWvg8QMifBbXl9dw5CQkJCQ|V1ZTRTHbRItUJEBFD6/BRo0MhQAAAABFhcl+YUGD6QFFD7bSSYnQQcHpAkqNdIoERQ+2WANBD7ZAAkmDwARIg8EEQQ+vw5lB9/qJx0EPtkD9QQ+vw5lB9/pBicFBD7ZA/ECIefxEiEn9QQ+vw0SIWf+ZQff6iEH+TDnGdbNEidhbXl/DkJCQkJCQkJCQkJCQ")
                this._dtc := this.mcode("VVdWU4PsEIt8JCQPtheE0g+EKgEAADHtx0QkBAAAAAAx9jHAx0QkDAAAAAC7CQAAADHJx0QkCAAAAACJLCTrQI1Kn4D5BXdojUqpD7bRuQcAAACDwAEp2cHhAtPiAdaD+wd0XIPDAQ+2FAeJwYTSD4S2AAAAPQAQAAAPhKsAAACD+wl1u41oAYD6fHQLiejr1o20JgAAAACAfA8BY3XuiUQkDDH2g8ACMdvru410JgCNSr+A+QV3WI1KyeuOjXYAixQki2wkKINEJAgBidPB4wKJHCSLXCQEiUQkBI1LAYlMlQCLTCQMKdmJ64ssJIlMKwSJdCsIidODwwOJHCS7CQAAAOlf////kI20JgAAAACNStCA+QkPhi////+JwbsJAAAAhNIPhUr///+LRCQIg8QQW15fXcOJ9o28JwAAAADHRCQIAAAAAItEJAiDxBBbXl9dw5CQkJCQkJCQkJCQkA==|QVVBVFVXVlNJicsPtgmEyQ+EEgEAADH2Mdsx7UUx0kG5CQAAAEUx5DHARTHAvwcAAADrSA8fQABEjUGfQYD4BXdORI1BqYn5RQ+2wIPAAUQpycHhAkHT4EUBwkGD+Qd0P0GDwQFMY8BDD7YMA4TJD4SCAAAAPQAQAAB0e0GD+Ql1tkSNaAGA+Xx0fUSJ6OvVRI1Bv0GA+AV3PkSNQcnrpkxjw0SNTgGDwwNBg8QBRokMgkqNDIUAAAAAQYnoQbkJAAAAQSnwRIlUCgiJxkSJRAoE65EPH0AARI1B0EGA+AkPhmD///9MY8BBuQkAAACEyQ+Ffv///0SJ4FteX11BXEFdww8fRAAAQ4B8AwFjD4V3////icVFMdKDwAJFMcnpQf///w8fQABFMeREieBbXl9dQVxBXcOQkJCQkJCQkJA=")
                
                this.LoadLib("d2d1","dwrite","dwmapi","gdiplus")
                VarSetCapacity(gsi, 24, 0)
                NumPut(1,gsi,0,"uint")
                DllCall("gdiplus\GdiplusStartup", "Ptr*", token, "Ptr", &gsi, "Ptr", 0)
                this.gdiplusToken := token
                this._guid("{06152247-6f50-465a-9245-118bfd3b6007}",clsidFactory)
                this._guid("{b859ee5a-d838-4b5b-a2e8-1adc7d93db48}",clsidwFactory)
                
                if (clickThrough)
                    gui %guiID%: +hwndhwnd -Caption +E0x80000 +E0x20
                else
                    gui %guiID%: +hwndhwnd -Caption +E0x80000
                if (alwaysOnTop)
                    gui %guiID%: +AlwaysOnTop
                if (!taskBarIcon)
                    gui %guiID%: +ToolWindow
                
                this.hwnd := hwnd
                DllCall("ShowWindow","Uptr",this.hwnd,"uint",(clickThrough ? 8 : 1))

                OnMessage(0x14,"ShinsOverlayClass_OnErase")

                this.tBufferPtr := this.SetVarCapacity("ttBuffer",4096)
                this.rect1Ptr := this.SetVarCapacity("_rect1",64)
                this.rect2Ptr := this.SetVarCapacity("_rect2",64)
                this.rtPtr := this.SetVarCapacity("_rtPtr",64)
                this.hrtPtr := this.SetVarCapacity("_hrtPtr",64)
                this.matrixPtr := this.SetVarCapacity("_matrix",64)
                this.colPtr := this.SetVarCapacity("_colPtr",64)
                this.clrPtr := this.SetVarCapacity("_clrPtr",64)
                VarSetCapacity(margins,16)
                NumPut(-1,margins,0,"int"), NumPut(-1,margins,4,"int"), NumPut(-1,margins,8,"int"), NumPut(-1,margins,12,"int")
                ext := DllCall("dwmapi\DwmExtendFrameIntoClientArea","Uptr",hwnd,"ptr",&margins,"uint")
                if (ext != 0) {
                    this.Err("Problem with DwmExtendFrameIntoClientArea","overlay will not function`n`nReloading the script usually fixes this`n`nError: " DllCall("GetLastError","uint") " / " ext)
                    return
                }
                DllCall("SetLayeredWindowAttributes","Uptr",hwnd,"Uint",0,"char",255,"uint",2)
                if (DllCall("d2d1\D2D1CreateFactory","uint",1,"Ptr",&clsidFactory,"uint*",0,"Ptr*",factory) != 0) {
                    this.Err("Problem creating factory","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
                    return
                }
                this.factory := factory
                NumPut(255,this.tBufferPtr,16,"float")
                if (DllCall(this.vTable(this.factory,11),"ptr",this.factory,"ptr",this.tBufferPtr,"ptr",0,"uint",0,"ptr*",stroke) != 0) {
                    this.Err("Problem creating stroke","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
                    return
                }
                this.stroke := stroke
                NumPut(2,this.tBufferPtr,0,"uint")
                NumPut(2,this.tBufferPtr,4,"uint")
                NumPut(2,this.tBufferPtr,12,"uint")
                NumPut(255,this.tBufferPtr,16,"float")
                if (DllCall(this.vTable(this.factory,11),"ptr",this.factory,"ptr",this.tBufferPtr,"ptr",0,"uint",0,"ptr*",stroke) != 0) {
                    this.Err("Problem creating rounded stroke","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
                    return
                }
                this.strokeRounded := stroke
                NumPut(1,this.rtPtr,8,"uint")
                NumPut(96,this.rtPtr,12,"float")
                NumPut(96,this.rtPtr,16,"float")
                NumPut(hwnd,this.hrtPtr,0,"Uptr")
                NumPut(width_orForeground,this.hrtPtr,a_ptrsize,"uint")
                NumPut(height,this.hrtPtr,a_ptrsize+4,"uint")
                NumPut((vsync?0:2),this.hrtPtr,a_ptrsize+8,"uint")
                if (DllCall(this.vTable(this.factory,14),"Ptr",this.factory,"Ptr",this.rtPtr,"ptr",this.hrtPtr,"Ptr*",renderTarget) != 0) {
                    this.Err("Problem creating renderTarget","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
                    return
                }
                this.renderTarget := renderTarget
                NumPut(1,this.matrixPtr,0,"float")
                this.SetIdentity(4)
                if (DllCall(this.vTable(this.renderTarget,8),"Ptr",this.renderTarget,"Ptr",this.colPtr,"Ptr",this.matrixPtr,"Ptr*",brush) != 0) {
                    this.Err("Problem creating brush","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
                    return
                }
                this.brush := brush
                DllCall(this.vTable(this.renderTarget,32),"Ptr",this.renderTarget,"Uint",1)
                if (DllCall("dwrite\DWriteCreateFactory","uint",0,"Ptr",&clsidwFactory,"Ptr*",wFactory) != 0) {
                    this.Err("Problem creating writeFactory","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
                    return
                }
                this.wFactory := wFactory

                this.InitFuncs()
                
                if (x_orTitle != 0 and winexist(x_orTitle))
                    this.AttachToWindow(x_orTitle,y_orClient,width_orForeground)
                else
                    this.SetPosition(x_orTitle,y_orClient)
                

                this.Clear()

            }
            
            ;####################################################################################################################################################################################################################################
            ;AttachToWindow
            ;
            ;title              :               Title of the window (or other type of identifier such as 'ahk_exe notepad.exe' etc..
            ;attachToClientArea :               Whether or not to attach the overlay to the client area, window area is used otherwise
            ;foreground         :               Whether or not to only draw the overlay if attached window is active in the foreground, otherwise always draws
            ;setOwner           :               Sets the ownership of the overlay window to the target window
            ;
            ;return             ;               Returns 1 if either attached window is active in the foreground or no window is attached; 0 otherwise
            ;
            ;Notes              ;               Does not actually 'attach', but rather every BeginDraw() fuction will check to ensure it's 
            ;                                   updated to the attached windows position/size
            ;                                   Could use SetParent but it introduces other issues, I'll explore further later
            
            AttachToWindow(title,AttachToClientArea:=0,foreground:=1,setOwner:=0) {
                if (title = "") {
                    this.Err("AttachToWindow: Error","Expected title string, but empty variable was supplied!")
                    return 0
                }
                if (!this.attachHWND := winexist(title)) {
                    this.Err("AttachToWindow: Error","Could not find window - " title)
                    return 0
                }
                numput(this.attachHwnd,this.tbufferptr,0,"UPtr")
                this.attachHWND := numget(this.tbufferptr,0,"Uptr")
                if (!DllCall("GetWindowRect","Uptr",this.attachHWND,"ptr",this.tBufferPtr)) {
                    this.Err("AttachToWindow: Error","Problem getting window rect, is window minimized?`n`nError: " DllCall("GetLastError","uint"))
                    return 0
                }
                x := NumGet(this.tBufferPtr,0,"int")
                y := NumGet(this.tBufferPtr,4,"int")
                w := NumGet(this.tBufferPtr,8,"int")-x
                h := NumGet(this.tBufferPtr,12,"int")-y
                this.attachClient := AttachToClientArea
                this.attachForeground := foreground
                this.AdjustWindow(x,y,w,h)
                
                VarSetCapacity(newSize,16)
                NumPut(this.width,newSize,0,"uint")
                NumPut(this.height,newSize,4,"uint")
                DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
                this.SetPosition(x,y,this.width,this.height)
                if (setOwner) {
                    this.alwaysontop := 0
                    WinSet, AlwaysOnTop, off, % "ahk_id " this.hwnd
                    this.owned := 1
                    dllcall("SetWindowLongPtr","Uptr",this.hwnd,"int",-8,"Uptr",this.attachHWND)
                    this.SetPosition(this.x,this.y)
                } else {
                    this.owned := 0
                }
            }
            
            ;####################################################################################################################################################################################################################################
            ;BeginDraw
            ;
            ;return             ;               Returns 1 if either attached window is active in the foreground or no window is attached; 0 otherwise
            ;
            ;Notes              ;               Must always call EndDraw to finish drawing and update the overlay
            
            BeginDraw() {
                if (this.attachHWND) {
                    if (!DllCall("GetWindowRect","Uptr",this.attachHWND,"ptr",this.tBufferPtr) or (this.attachForeground and DllCall("GetForegroundWindow","cdecl Ptr") != this.attachHWND)) {
                        if (this.drawing) {
                            if (this.callbacks["active"])
                                this.callbacks["active"].call(this,0)
                            this.Clear()
                            this.drawing := 0
                            if (this.HideOnStateChange)
                                this.Display(1)
                        }
                        return 0
                    }
                    x := NumGet(this.tBufferPtr,0,"int")
                    y := NumGet(this.tBufferPtr,4,"int")
                    w := NumGet(this.tBufferPtr,8,"int")-x
                    h := NumGet(this.tBufferPtr,12,"int")-y
                    if ((w<<16)+h != this.lastSize) {
                        this.AdjustWindow(x,y,w,h)
                        VarSetCapacity(newSize,16,0)
                        NumPut(this.width,newSize,0,"uint")
                        NumPut(this.height,newSize,4,"uint")
                        DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
                        this.SetPosition(x,y)
                        if (this.callbacks["size"])
                            this.callbacks["size"].call(this)
                    } else if ((x<<16)+y != this.lastPos) {
                        this.AdjustWindow(x,y,w,h)
                        this.SetPosition(x,y)
                        if (this.callbacks["position"])
                            this.callbacks["position"].call(this)
                    }
                    if (!this.drawing and this.alwaysontop) {
                        winset,alwaysontop,on,% "ahk_id " this.hwnd
                    }
                    
                } else {
                    if (!DllCall("GetWindowRect","Uptr",this.hwnd,"ptr",this.tBufferPtr)) {
                        if (this.drawing) {
                            if (this.callbacks["active"])
                                this.callbacks["active"].call(this,0)
                            this.Clear()
                            this.drawing := 0
                        }
                        return 0
                    }
                    x := NumGet(this.tBufferPtr,0,"int")
                    y := NumGet(this.tBufferPtr,4,"int")
                    w := NumGet(this.tBufferPtr,8,"int")-x
                    h := NumGet(this.tBufferPtr,12,"int")-y
                    if ((w<<16)+h != this.lastSize) {
                        this.AdjustWindow(x,y,w,h)
                        VarSetCapacity(newSize,16)
                        NumPut(this.width,newSize,0,"uint")
                        NumPut(this.height,newSize,4,"uint")
                        DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
                        this.SetPosition(x,y)
                        if (this.callbacks["size"])
                            this.callbacks["size"].call(this)
                    } else if ((x<<16)+y != this.lastPos) {
                        this.AdjustWindow(x,y,w,h)
                        this.SetPosition(x,y)
                        if (this.callbacks["position"])
                            this.callbacks["position"].call(this)
                    }
                }
                
                DllCall(this._BeginDraw,"Ptr",this.renderTarget)
                DllCall(this._Clear,"Ptr",this.renderTarget,"Ptr",this.clrPtr)
                if (this.drawing = 0) {
                    if (this.callbacks["active"])
                        this.callbacks["active"].call(this,1)
                    if (this.HideOnStateChange)
                        this.Display(0)
                }
                return this.drawing := 1
            }
            
            ;####################################################################################################################################################################################################################################
            ;EndDraw
            ;
            ;return             ;               Void
            ;
            ;Notes              ;               Must always call EndDraw to finish drawing and update the overlay
            
            EndDraw() {
                if (this.drawing)
                    DllCall(this._EndDraw,"Ptr",this.renderTarget,"Ptr*",tag1,"Ptr*",tag2)
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawImage
            ;
            ;dstX               :               X position to draw to
            ;dstY               :               Y position to draw to
            ;dstW               :               Width of image to draw to
            ;dstH               :               Height of image to draw to
            ;srcX               :               X position to draw from
            ;srcY               :               Y position to draw from
            ;srcW               :               Width of image to draw from
            ;srcH               :               Height of image to draw from
            ;alpha              :               Image transparency, float between 0 and 1
            ;drawCentered       :               Draw the image centered on dstX/dstY, otherwise dstX/dstY will be the top left of the image
            ;rotation           :               Image rotation in degrees (0-360)
            ;rotationOffsetX    :               X offset to base rotations on (defaults to center x)
            ;rotationOffsetY    :               Y offset to base rotations on (defaults to center y)
            ;
            ;return             ;               Void
            
            DrawImage(image,dstX,dstY,dstW:=0,dstH:=0,srcX:=0,srcY:=0,srcW:=0,srcH:=0,alpha:=1,drawCentered:=0,rotation:=0,rotOffX:=0,rotOffY:=0) {
                if (!i := this.imageCache[image]) {
                    i := this.cacheImage(image)
                }
                if (dstW <= 0)
                    dstW := i.w
                if (dstH <= 0)
                    dstH := i.h
                x := dstX-(drawCentered?dstW/2:0)
                y := dstY-(drawCentered?dstH/2:0)
                NumPut(x,this.rect1Ptr,0,"float")
                NumPut(y,this.rect1Ptr,4,"float")
                NumPut(x + dstW,this.rect1Ptr,8,"float")
                NumPut(y + dstH,this.rect1Ptr,12,"float")
                NumPut(srcX,this.rect2Ptr,0,"float")
                NumPut(srcY,this.rect2Ptr,4,"float")
                NumPut(srcX + (srcW=0?i.w:srcW),this.rect2Ptr,8,"float")
                NumPut(srcY + (srcH=0?i.h:srcH),this.rect2Ptr,12,"float")
                
                if (rotation != 0) {
                    if (this.bits) {
                        if (rotOffX or rotOffY) {
                            NumPut(dstX+rotOffX,this.tBufferPtr,0,"float")
                            NumPut(dstY+rotOffY,this.tBufferPtr,4,"float")
                        } else {
                            NumPut(dstX+(drawCentered?0:dstW/2),this.tBufferPtr,0,"float")
                            NumPut(dstY+(drawCentered?0:dstH/2),this.tBufferPtr,4,"float")
                        }
                        DllCall("d2d1\D2D1MakeRotateMatrix","float",rotation,"double",NumGet(this.tBufferPtr,"double"),"ptr",this.matrixPtr)
                    } else {
                        DllCall("d2d1\D2D1MakeRotateMatrix","float",rotation,"float",dstX+(drawCentered?0:dstW/2),"float",dstY+(drawCentered?0:dstH/2),"ptr",this.matrixPtr)
                    }
                    DllCall(this._RMatrix,"ptr",this.renderTarget,"ptr",this.matrixPtr)
                    DllCall(this._DrawImage,"ptr",this.renderTarget,"ptr",i.p,"ptr",this.rect1Ptr,"float",alpha,"uint",this.interpolationMode,"ptr",this.rect2Ptr)
                    this.SetIdentity()
                    DllCall(this._RMatrix,"ptr",this.renderTarget,"ptr",this.matrixPtr)
                } else {
                    DllCall(this._DrawImage,"ptr",this.renderTarget,"ptr",i.p,"ptr",this.rect1Ptr,"float",alpha,"uint",this.interpolationMode,"ptr",this.rect2Ptr)
                }
            }
            
            ;####################################################################################################################################################################################################################################
            ;GetTextMetrics
            ;
            ;text               :               The text to get the metrics of
            ;size               :               Font size to measure with
            ;fontName           :               Name of the font to use
            ;maxWidth           :               Max width (smaller width may cause wrapping)
            ;maxHeight          :               Max Height
            ;
            ;return             ;               An array containing width, height and line count of the string
            ;
            ;Notes              ;               Used to measure a string before drawing it
            
            GetTextMetrics(text,size,fontName,maxWidth:=5000,maxHeight:=5000) {
                local
                if (!p := this.fonts[fontName size "400"]) {
                    p := this.CacheFont(fontName,size)
                }
                varsetcapacity(bf,64)
                DllCall(this.vTable(this.wFactory,18),"ptr",this.wFactory,"WStr",text,"uint",strlen(text),"Ptr",p,"float",maxWidth,"float",maxHeight,"Ptr*",layout)
                DllCall(this.vTable(layout,60),"ptr",layout,"ptr",&bf,"uint")
                
                w := numget(bf,8,"float")
                wTrailing := numget(bf,12,"float")
                h := numget(bf,16,"float")
                
                DllCall(this.vTable(layout,2),"ptr",layout)
                
                return {w:w,width:w,h:h,height:h,wt:wTrailing,widthTrailing:w,lines:numget(bf,32,"uint")}
                
            }
            
            ;####################################################################################################################################################################################################################################
            ;SetTextRenderParams
            ;
            ;gamma              :               Gamma value ................. (1 > 256)
            ;contrast           :               Contrast value .............. (0.0 > 1.0)
            ;clearType          :               Clear type level ............ (0.0 > 1.0)
            ;pixelGeom          :               
            ;                                   0 - DWRITE_PIXEL_GEOMETRY_FLAT
            ;                                   1 - DWRITE_PIXEL_GEOMETRY_RGB
            ;                                   2 - DWRITE_PIXEL_GEOMETRY_BGR
            ;
            ;renderMode         :               
            ;                                   0 - DWRITE_RENDERING_MODE_DEFAULT
            ;                                   1 - DWRITE_RENDERING_MODE_ALIASED
            ;                                   2 - DWRITE_RENDERING_MODE_GDI_CLASSIC
            ;                                   3 - DWRITE_RENDERING_MODE_GDI_NATURAL
            ;                                   4 - DWRITE_RENDERING_MODE_NATURAL
            ;                                   5 - DWRITE_RENDERING_MODE_NATURAL_SYMMETRIC
            ;                                   6 - DWRITE_RENDERING_MODE_OUTLINE
            ;                                   7 - DWRITE_RENDERING_MODE_CLEARTYPE_GDI_CLASSIC
            ;                                   8 - DWRITE_RENDERING_MODE_CLEARTYPE_GDI_NATURAL
            ;                                   9 - DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL
            ;                                   10 - DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL_SYMMETRIC
            ;
            ;return             ;               Void
            ;
            ;Notes              ;               Used to affect how text is rendered
            
            SetTextRenderParams(gamma:=1,contrast:=0,cleartype:=1,pixelGeom:=0,renderMode:=0) {
                local
                DllCall(this.vTable(this.wFactory,12),"ptr",this.wFactory,"Float",gamma,"Float",contrast,"Float",cleartype,"Uint",pixelGeom,"Uint",renderMode,"Ptr*",params) "`n" params
                DllCall(this.vTable(this.renderTarget,36),"Ptr",this.renderTarget,"Ptr",params)
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawText
            ;
            ;text               :               The text to be drawn
            ;x                  :               X position
            ;y                  :               Y position
            ;size               :               Size of font
            ;color              :               Color of font
            ;fontName           :               Font name (must be installed)
            ;extraOptions       :               Additonal options which may contain any of the following seperated by spaces:
            ;                                   Width ............. w[number]               : Example > w200            (Default: this.width)
            ;                                   Height ............ h[number]               : Example > h200            (Default: this.height)
            ;                                   Alignment ......... a[Left/Right/Center]    : Example > aCenter         (Default: Left)
            ;                                   DropShadow ........ ds[hex color]           : Example > dsFF000000      (Default: DISABLED)
            ;                                   DropShadowXOffset . dsx[number]             : Example > dsx2            (Default: 1)
            ;                                   DropShadowYOffset . dsy[number]             : Example > dsy2            (Default: 1)
            ;                                   Outline ........... ol[hex color]           : Example > olFF000000      (Default: DISABLED)
            ;
            ;return             ;               Void
            
            DrawText(text,x,y,size:=18,color:=0xFFFFFFFF,fontName:="Arial",extraOptions:="") {
                local
                if (!RegExMatch(extraOptions,"w([\d\.]+)",w))
                    w1 := this.width
                if (!RegExMatch(extraOptions,"h([\d\.]+)",h))
                    h1 := this.height
                bold := (RegExMatch(extraOptions,"bold") ? 700 : 400)
                
                if (!p := this.fonts[fontName size bold]) {
                    p := this.CacheFont(fontName,size,bold)
                }
                
                DllCall(this.vTable(p,3),"ptr",p,"uint",(InStr(extraOptions,"aRight") ? 1 : InStr(extraOptions,"aCenter") ? 2 : 0))
                
                if (RegExMatch(extraOptions,"ds([a-fA-F\d]+)",ds)) {
                    if (!RegExMatch(extraOptions,"dsx([\d\.]+)",dsx))
                        dsx1 := 1
                    if (!RegExMatch(extraOptions,"dsy([\d\.]+)",dsy))
                        dsy1 := 1
                    this.DrawTextShadow(p,text,x+dsx1,y+dsy1,w1,h1,"0x" ds1)
                } else if (RegExMatch(extraOptions,"ol(\w{8})",ol)) {
                    this.DrawTextOutline(p,text,x,y,w1,h1,"0x" ol1)
                }
                
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(x+w1,this.tBufferPtr,8,"float")
                NumPut(y+h1,this.tBufferPtr,12,"float")
                
                DllCall(this._DrawText,"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
            }
            
            DrawTextExt(text,x,y,size:=18,color:=0xFFFFFFFF,fontName:="Arial",extraOptions:="") {
                local
                if (!RegExMatch(extraOptions,"w([\d\.]+)",w))
                    w1 := this.width
                if (!RegExMatch(extraOptions,"h([\d\.]+)",h))
                    h1 := this.height
                bold := (RegExMatch(extraOptions,"i)bold") ? 700 : 400)
                
                if (!p := this.fonts[fontName size bold]) {
                    p := this.CacheFont(fontName,size,bold)
                }
                
                DllCall(this.vTable(p,3),"ptr",p,"uint",(InStr(extraOptions,"aRight") ? 1 : InStr(extraOptions,"aCenter") ? 2 : 0))
                
                if (RegExMatch(extraOptions,"ds([a-fA-F\d]+)",ds)) {
                    if (!RegExMatch(extraOptions,"dsx([\d\.]+)",dsx))
                        dsx1 := 1
                    if (!RegExMatch(extraOptions,"dsy([\d\.]+)",dsy))
                        dsy1 := 1
                    this.DrawTextShadow(p,text,x+dsx1,y+dsy1,w1,h1,"0x" ds1)
                } else if (RegExMatch(extraOptions,"ol(\w{8})",ol)) {
                    this.DrawTextOutline(p,text,x,y,w1,h1,"0x" ol1)
                }
                if (InStr(text,"|c")) {
                    varsetcapacity(res,512,0)
                    varsetcapacity(_dat,(strlen(text)+1)*4,0)
                    strput(text,&_dat,"utf-8")
                    if (t := dllcall(this._dtc,"ptr",&_dat,"ptr",&res)) {
                        loop % t {
                            i := ((a_index-1)*12)
                            s := numget(res,i,"int"),
                            if (e := numget(res,i+4,"int")) {
                                str := substr(text,s,e)
                                this.SetBrushColor(color)
                                NumPut(x,this.tBufferPtr,0,"float"),NumPut(y,this.tBufferPtr,4,"float")
                                NumPut(x+w1,this.tBufferPtr,8,"float"),NumPut(y+h1,this.tBufferPtr,12,"float")
                                DllCall(this._DrawText,"ptr",this.renderTarget,"wstr",str,"uint",strlen(str),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
                                mets := this.GetTextMetrics(str,size,fontName)
                                x+=mets.wt
                            }
                            color := numget(res,i+8,"uint")
                        }
                        str := substr(text,s+e+10)
                        this.SetBrushColor(color)
                        NumPut(x,this.tBufferPtr,0,"float"),NumPut(y,this.tBufferPtr,4,"float")
                        NumPut(x+w1,this.tBufferPtr,8,"float"),NumPut(y+h1,this.tBufferPtr,12,"float")
                        DllCall(this._DrawText,"ptr",this.renderTarget,"wstr",str,"uint",strlen(str),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
                    } else {
                        this.SetBrushColor(color)
                        NumPut(x,this.tBufferPtr,0,"float"),NumPut(y,this.tBufferPtr,4,"float")
                        NumPut(x+w1,this.tBufferPtr,8,"float"),NumPut(y+h1,this.tBufferPtr,12,"float")
                        DllCall(this._DrawText,"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
                    }
                } else {
                    this.SetBrushColor(color)
                    NumPut(x,this.tBufferPtr,0,"float"),NumPut(y,this.tBufferPtr,4,"float")
                    NumPut(x+w1,this.tBufferPtr,8,"float"),NumPut(y+h1,this.tBufferPtr,12,"float")
                    DllCall(this._DrawText,"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
                }
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawEllipse
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;w                  :               Width of ellipse
            ;h                  :               Height of ellipse
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;thickness          :               Thickness of the line
            ;
            ;return             ;               Void
            
            DrawEllipse(x, y, w, h, color, thickness:=1) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(w,this.tBufferPtr,8,"float")
                NumPut(h,this.tBufferPtr,12,"float")
                DllCall(this._DrawEllipse,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
            }
            
            
            ;####################################################################################################################################################################################################################################
            ;FillEllipse
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;w                  :               Width of ellipse
            ;h                  :               Height of ellipse
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;
            ;return             ;               Void
            
            FillEllipse(x, y, w, h, color) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(w,this.tBufferPtr,8,"float")
                NumPut(h,this.tBufferPtr,12,"float")
                DllCall(this._FillEllipse,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawCircle
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;radius             :               Radius of circle
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;thickness          :               Thickness of the line
            ;
            ;return             ;               Void
            
            DrawCircle(x, y, radius, color, thickness:=1) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(radius,this.tBufferPtr,8,"float")
                NumPut(radius,this.tBufferPtr,12,"float")
                DllCall(this._DrawEllipse,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
            }
            
            ;####################################################################################################################################################################################################################################
            ;FillCircle
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;radius             :               Radius of circle
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;
            ;return             ;               Void
            
            FillCircle(x, y, radius, color) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(radius,this.tBufferPtr,8,"float")
                NumPut(radius,this.tBufferPtr,12,"float")
                DllCall(this._FillEllipse,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawRectangle
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;w                  :               Width of rectangle
            ;h                  :               Height of rectangle
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;thickness          :               Thickness of the line
            ;
            ;return             ;               Void
            
            DrawRectangle(x, y, w, h, color, thickness:=1) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(x+w,this.tBufferPtr,8,"float")
                NumPut(y+h,this.tBufferPtr,12,"float")
                DllCall(this._DrawRectangle,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
            }
            
            ;####################################################################################################################################################################################################################################
            ;FillRectangle
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;w                  :               Width of rectangle
            ;h                  :               Height of rectangle
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;
            ;return             ;               Void
            
            FillRectangle(x, y, w, h, color) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(x+w,this.tBufferPtr,8,"float")
                NumPut(y+h,this.tBufferPtr,12,"float")
                DllCall(this._FillRectangle,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawRoundedRectangle
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;w                  :               Width of rectangle
            ;h                  :               Height of rectangle
            ;radiusX            :               The x-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
            ;radiusY            :               The y-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;thickness          :               Thickness of the line
            ;
            ;return             ;               Void
            
            DrawRoundedRectangle(x, y, w, h, radiusX, radiusY, color, thickness:=1) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(x+w,this.tBufferPtr,8,"float")
                NumPut(y+h,this.tBufferPtr,12,"float")
                NumPut(radiusX,this.tBufferPtr,16,"float")
                NumPut(radiusY,this.tBufferPtr,20,"float")
                DllCall(this._DrawRoundedRectangle,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
            }
            
            ;####################################################################################################################################################################################################################################
            ;FillRectangle
            ;
            ;x                  :               X position
            ;y                  :               Y position
            ;w                  :               Width of rectangle
            ;h                  :               Height of rectangle
            ;radiusX            :               The x-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
            ;radiusY            :               The y-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;
            ;return             ;               Void
            
            FillRoundedRectangle(x, y, w, h, radiusX, radiusY, color) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(x+w,this.tBufferPtr,8,"float")
                NumPut(y+h,this.tBufferPtr,12,"float")
                NumPut(radiusX,this.tBufferPtr,16,"float")
                NumPut(radiusY,this.tBufferPtr,20,"float")
                DllCall(this._FillRoundedRectangle,"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawLine
            ;
            ;x1                 :               X position for line start
            ;y1                 :               Y position for line start
            ;x2                 :               X position for line end
            ;y2                 :               Y position for line end
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;thickness          :               Thickness of the line
            ;
            ;return             ;               Void

            DrawLine(x1,y1,x2,y2,color:=0xFFFFFFFF,thickness:=1,rounded:=0) {
                this.SetBrushColor(color)
                if (this.bits) {
                    NumPut(x1,this.tBufferPtr,0,"float")  ;Special thanks to teadrinker for helping me
                    NumPut(y1,this.tBufferPtr,4,"float")  ;with these params!
                    NumPut(x2,this.tBufferPtr,8,"float")
                    NumPut(y2,this.tBufferPtr,12,"float")
                    DllCall(this._DrawLine,"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
                } else {
                    DllCall(this._DrawLine,"Ptr",this.renderTarget,"float",x1,"float",y1,"float",x2,"float",y2,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
                }
                
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawLines
            ;
            ;lines              :               An array of 2d points, example: [[0,0],[5,0],[0,5]]
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;connect            :               If 1 then connect the start and end together
            ;thickness          :               Thickness of the line
            ;
            ;return             ;               1 on success; 0 otherwise

            DrawLines(points,color,connect:=0,thickness:=1,rounded:=0) {
                if (points.length() < 2)
                    return 0
                lx := sx := points[1][1]
                ly := sy := points[1][2]
                this.SetBrushColor(color)
                if (this.bits) {
                    loop % points.length()-1 {
                        NumPut(lx,this.tBufferPtr,0,"float"), NumPut(ly,this.tBufferPtr,4,"float"), NumPut(lx:=points[a_index+1][1],this.tBufferPtr,8,"float"), NumPut(ly:=points[a_index+1][2],this.tBufferPtr,12,"float")
                        DllCall(this._DrawLine,"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
                    }
                    if (connect) {
                        NumPut(sx,this.tBufferPtr,0,"float"), NumPut(sy,this.tBufferPtr,4,"float"), NumPut(lx,this.tBufferPtr,8,"float"), NumPut(ly,this.tBufferPtr,12,"float")
                        DllCall(this._DrawLine,"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
                    }
                } else {
                    loop % points.length()-1 {
                        x1 := lx
                        y1 := ly
                        x2 := lx := points[a_index+1][1]
                        y2 := ly := points[a_index+1][2]
                        DllCall(this._DrawLine,"Ptr",this.renderTarget,"float",x1,"float",y1,"float",x2,"float",y2,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
                    }
                    if (connect)
                        DllCall(this._DrawLine,"Ptr",this.renderTarget,"float",sx,"float",sy,"float",lx,"float",ly,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
                }
                return 1
            }
            
            ;####################################################################################################################################################################################################################################
            ;DrawPolygon
            ;
            ;points             :               An array of 2d points, example: [[0,0],[5,0],[0,5]]
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;thickness          :               Thickness of the line
            ;xOffset            :               X offset to draw the polygon array
            ;yOffset            :               Y offset to draw the polygon array
            ;
            ;return             ;               1 on success; 0 otherwise

            DrawPolygon(points,color,thickness:=1,rounded:=0,xOffset:=0,yOffset:=0) {
                if (points.length() < 3)
                    return 0
                
                if (DllCall(this.vTable(this.factory,10),"Ptr",this.factory,"Ptr*",pGeom) = 0) {
                    if (DllCall(this.vTable(pGeom,17),"Ptr",pGeom,"ptr*",sink) = 0) {
                        this.SetBrushColor(color)
                        if (this.bits) {
                            numput(points[1][1]+xOffset,this.tBufferPtr,0,"float")
                            numput(points[1][2]+yOffset,this.tBufferPtr,4,"float")
                            DllCall(this.vTable(sink,5),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"),"uint",1)
                            loop % points.length()-1
                            {
                                numput(points[a_index+1][1]+xOffset,this.tBufferPtr,0,"float")
                                numput(points[a_index+1][2]+yOffset,this.tBufferPtr,4,"float")
                                DllCall(this.vTable(sink,10),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"))
                            }
                            DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
                            DllCall(this.vTable(sink,9),"ptr",sink)
                        } else {
                            DllCall(this.vTable(sink,5),"ptr",sink,"float",points[1][1]+xOffset,"float",points[1][2]+yOffset,"uint",1)
                            loop % points.length()-1
                                DllCall(this.vTable(sink,10),"ptr",sink,"float",points[a_index+1][1]+xOffset,"float",points[a_index+1][2]+yOffset)
                            DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
                            DllCall(this.vTable(sink,9),"ptr",sink)
                        }
                        
                        if (DllCall(this.vTable(this.renderTarget,22),"Ptr",this.renderTarget,"Ptr",pGeom,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke)) = 0) {
                            DllCall(this.vTable(sink,2),"ptr",sink)
                            DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
                            return 1
                        }
                        DllCall(this.vTable(sink,2),"ptr",sink)
                        DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
                    }
                }
                
                
                return 0
            }
            
            ;####################################################################################################################################################################################################################################
            ;FillPolygon
            ;
            ;points             :               An array of 2d points, example: [[0,0],[5,0],[0,5]]
            ;color              :               Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
            ;xOffset            :               X offset to draw the filled polygon array
            ;yOffset            :               Y offset to draw the filled polygon array
            ;
            ;return             ;               1 on success; 0 otherwise

            FillPolygon(points,color,xoffset:=0,yoffset:=0) {
                if (points.length() < 3)
                    return 0
                
                if (DllCall(this.vTable(this.factory,10),"Ptr",this.factory,"Ptr*",pGeom) = 0) {
                    if (DllCall(this.vTable(pGeom,17),"Ptr",pGeom,"ptr*",sink) = 0) {
                        this.SetBrushColor(color)
                        if (this.bits) {
                            numput(points[1][1]+xoffset,this.tBufferPtr,0,"float")
                            numput(points[1][2]+yoffset,this.tBufferPtr,4,"float")
                            DllCall(this.vTable(sink,5),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"),"uint",0)
                            loop % points.length()-1
                            {
                                numput(points[a_index+1][1]+xoffset,this.tBufferPtr,0,"float")
                                numput(points[a_index+1][2]+yoffset,this.tBufferPtr,4,"float")
                                DllCall(this.vTable(sink,10),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"))
                            }
                            DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
                            DllCall(this.vTable(sink,9),"ptr",sink)
                        } else {
                            DllCall(this.vTable(sink,5),"ptr",sink,"float",points[1][1]+xoffset,"float",points[1][2]+yoffset,"uint",0)
                            loop % points.length()-1
                                DllCall(this.vTable(sink,10),"ptr",sink,"float",points[a_index+1][1]+xoffset,"float",points[a_index+1][2]+yoffset)
                            DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
                            DllCall(this.vTable(sink,9),"ptr",sink)
                        }
                        
                        if (DllCall(this.vTable(this.renderTarget,23),"Ptr",this.renderTarget,"Ptr",pGeom,"ptr",this.brush,"ptr",0) = 0) {
                            DllCall(this.vTable(sink,2),"ptr",sink)
                            DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
                            return 1
                        }
                        DllCall(this.vTable(sink,2),"ptr",sink)
                        DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
                        
                    }
                }
                
                
                return 0
            }
            
            ;####################################################################################################################################################################################################################################
            ;SetPosition
            ;
            ;x                  :               X position to move the window to (screen space)
            ;y                  :               Y position to move the window to (screen space)
            ;w                  :               New Width (only applies when not attached)
            ;h                  :               New Height (only applies when not attached)
            ;
            ;return             ;               Void
            ;
            ;notes              :               Only used when not attached to a window
            
            SetPosition(x,y,w:=0,h:=0) {
                this.x := x
                this.y := y
                if (!this.attachHWND and w != 0 and h != 0) {
                    VarSetCapacity(newSize,16)
                    NumPut(this.width := w,newSize,0,"uint")
                    NumPut(this.height := h,newSize,4,"uint")
                    DllCall(this._NRSize,"Ptr",this.renderTarget,"ptr",&newsize)
                }
                DllCall("MoveWindow","Uptr",this.hwnd,"int",x,"int",y,"int",this.width,"int",this.height,"char",1)
            }
            
            ;####################################################################################################################################################################################################################################
            ;GetImageDimensions
            ;
            ;image              :               Image file name
            ;&w                 :               Width of image
            ;&h                 :               Height of image
            ;
            ;return             ;               Void
            
            GetImageDimensions(image,byref w, byref h) {
                if (!i := this.imageCache[image]) {
                    i := this.cacheImage(image)
                }
                w := i.w
                h := i.h
            }
            
            ;####################################################################################################################################################################################################################################
            ;GetMousePos
            ;
            ;&x                 :               X position of mouse to return
            ;&y                 :               Y position of mouse to return
            ;realRegionOnly     :               Return 1 only if in the real region, which does not include the invisible borders, (client area does not have borders)
            ;
            ;return             ;               Returns 1 if mouse within window/client region; 0 otherwise
            
            GetMousePos(byref x, byref y, realRegionOnly:=0) {
                DllCall("GetCursorPos","ptr",this.tBufferPtr)
                x := NumGet(this.tBufferPtr,0,"int")
                y := NumGet(this.tBufferPtr,4,"int")
                if (!realRegionOnly) {
                    inside := (x >= this.x and y >= this.y and x <= this.x2 and y <= this.y2)
                    x += this.offX
                    y += this.offY
                    return inside
                }
                x += this.offX
                y += this.offY
                return (x >= this.realX and y >= this.realY and x <= this.realX2 and y <= this.realY2)
                
            }
            
            ;####################################################################################################################################################################################################################################
            ;Clear
            ;
            ;notes                      :           Clears the overlay, essentially the same as running BeginDraw followed by EndDraw
            
            Clear() {
                DllCall(this._BeginDraw,"Ptr",this.renderTarget)
                DllCall(this._Clear,"Ptr",this.renderTarget,"Ptr",this.clrPtr)
                DllCall(this._EndDraw,"Ptr",this.renderTarget,"Ptr*",tag1,"Ptr*",tag2)
            }
            
            ;####################################################################################################################################################################################################################################
            ;RegCallback
            ;
            ;&func                      :           Function object to call
            ;&callback                  :           Name of the callback to assign the function to
            ;
            ;notes                      :           Example: overlay.RegCallback(Func("funcName"),"Size"); See top for param info
            
            RegCallback(func,callback) {
                if (this.callbacks.haskey(callback))
                    this.callbacks[callback] := func
            }
            
            ;####################################################################################################################################################################################################################################
            ;ClearCallback
            ;
            ;&callback                  :           Name of the callback to clear functions of
            ;
            ;notes                      :           Clears callback
            
            ClearCallback(callback) {
                if (this.callbacks.haskey(callback))
                    this.callbacks[callback] := 0
            }   
            
            PushLayerRectangle(x,y,w,h) {
                VarSetCapacity(info,64,0)
                NumPut(x,info,0,"float")
                NumPut(y,info,4,"float")
                Numput(x+w,info,8,"float")
                NumPut(y+h,info,12,"float")
                if (DllCall(this.vTable(this.factory,5),"Ptr",this.factory,"Ptr",&info,"Ptr*",pGeom) = 0) {
                    NumPut(0xFF800000,info,0,"Uint")
                    NumPut(0xFF800000,info,4,"Uint")
                    Numput(0x7F800000,info,8,"Uint")
                    NumPut(0x7F800000,info,12,"Uint")
                    NumPut(pGeom,info,16,"Ptr"), i := 16 + a_ptrsize
                    NumPut(0,info,i,"Uint")
                    NumPut(1,info,i+4,"float")
                    NumPut(1,info,i+16,"float")
                    NumPut(1,info,i+28,"float")
                    DllCall(this.vTable(this.renderTarget,40),"Ptr",this.renderTarget, "Ptr", &info, "ptr", 0)
                    DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
                }
            }
            PushLayerEllipse(x,y,w,h) {
                VarSetCapacity(info,64,0)
                NumPut(x,info,0,"float")
                NumPut(y,info,4,"float")
                Numput(w,info,8,"float")
                NumPut(h,info,12,"float")
                if (DllCall(this.vTable(this.factory,7),"Ptr",this.factory,"Ptr",&info,"Ptr*",pGeom) = 0) {
                    NumPut(0xFF800000,info,0,"Uint")
                    NumPut(0xFF800000,info,4,"Uint")
                    Numput(0x7F800000,info,8,"Uint")
                    NumPut(0x7F800000,info,12,"Uint")
                    NumPut(pGeom,info,16,"Ptr"), i := 16 + a_ptrsize
                    NumPut(0,info,i,"Uint")
                    NumPut(1,info,i+4,"float")
                    NumPut(1,info,i+16,"float")
                    NumPut(1,info,i+28,"float")
                    DllCall(this.vTable(this.renderTarget,40),"Ptr",this.renderTarget, "Ptr", &info, "ptr", 0)
                    DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
                }
            }
            PopLayer() {
                DllCall(this.vTable(this.renderTarget,41),"Ptr",this.renderTarget)
            }
            
            ;0 = off
            ;1 = on
            SetAntialias(state:=0) {
                DllCall(this.vTable(this.renderTarget,32),"Ptr",this.renderTarget,"Uint",!state)
            }
            
            ;########################################## 
            ;  internal functions used by the class
            ;########################################## 
            AdjustWindow(byref x,byref y,byref w,byref h) {
                local
                this.lastPos := (x<<16)+y
                this.lastSize := (w<<16)+h
                DllCall("GetWindowInfo","Uptr",(this.attachHWND ? this.attachHWND : this.hwnd),"ptr",this.tBufferPtr)
                pp := (this.attachClient ? 20 : 4)
                x1 := NumGet(this.tBufferPtr,pp,"int")
                y1 := NumGet(this.tBufferPtr,pp+4,"int")
                x2 := NumGet(this.tBufferPtr,pp+8,"int")
                y2 := NumGet(this.tBufferPtr,pp+12,"int")
                this.width := w := x2-x1
                this.height := h := y2-y1
                this.x := x := x1
                this.y := y := y1
                this.x2 := x + w
                this.y2 := y + h
                
                hBorders := (this.attachClient ? 0 : NumGet(this.tBufferPtr,48,"int"))
                vBorders := (this.attachClient ? 0 : NumGet(this.tBufferPtr,52,"int"))
                this.realX := hBorders
                this.realY := 0
                this.realWidth := w - (hBorders*2)
                this.realHeight := h - vBorders
                this.realX2 := this.realX + this.realWidth
                this.realY2 := this.realY + this.realHeight
                this.offX := -x1 ;- hBorders
                this.offY := -y1
            }
            SetIdentity(o:=0) {
                NumPut(1,this.matrixPtr,o+0,"float")
                NumPut(0,this.matrixPtr,o+4,"float")
                NumPut(0,this.matrixPtr,o+8,"float")
                NumPut(1,this.matrixPtr,o+12,"float")
                NumPut(0,this.matrixPtr,o+16,"float")
                NumPut(0,this.matrixPtr,o+20,"float")
            }
            DrawTextShadow(p,text,x,y,w,h,color) {
                this.SetBrushColor(color)
                NumPut(x,this.tBufferPtr,0,"float")
                NumPut(y,this.tBufferPtr,4,"float")
                NumPut(x+w,this.tBufferPtr,8,"float")
                NumPut(y+h,this.tBufferPtr,12,"float")
                DllCall(this._DrawText,"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
            }
            DrawTextOutline(p,text,x,y,w,h,color) {
                static o := [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
                this.SetBrushColor(color)
                for k,v in o
                {
                    NumPut(x+v[1],this.tBufferPtr,0,"float")
                    NumPut(y+v[2],this.tBufferPtr,4,"float")
                    NumPut(x+w+v[1],this.tBufferPtr,8,"float")
                    NumPut(y+h+v[2],this.tBufferPtr,12,"float")
                    DllCall(this._DrawText,"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
                }
            }
            Err(str*) {
                local
                s := ""
                for k,v in str
                    s .= (s = "" ? "" : "`n`n") v
                msgbox,% 0x30 | 0x1000,% "Problem!",% s
            }
            LoadLib(lib*) {
                for k,v in lib
                    if (!DllCall("GetModuleHandle", "str", v, "Ptr"))
                        DllCall("LoadLibrary", "Str", v) 
            }
            SetBrushColor(col) {
                if (col <= 0xFFFFFF)
                    col += 0xFF000000
                if (col != this.lastCol) {
                    NumPut(((col & 0xFF0000)>>16)/255,this.colPtr,0,"float")
                    NumPut(((col & 0xFF00)>>8)/255,this.colPtr,4,"float")
                    NumPut(((col & 0xFF))/255,this.colPtr,8,"float")
                    NumPut((col > 0xFFFFFF ? ((col & 0xFF000000)>>24)/255 : 1),this.colPtr,12,"float")
                    DllCall(this._SetBrush,"Ptr",this.brush,"Ptr",this.colPtr)
                    this.lastCol := col
                    return 1
                }
                return 0
            }
            vTable(a,p) {
                return NumGet(NumGet(a+0,0,"ptr"),p*a_ptrsize,"Ptr")
            }
            _guid(guidStr,byref clsid) {
                VarSetCapacity(clsid,16)
                DllCall("ole32\CLSIDFromString", "WStr", guidStr, "Ptr", &clsid)
            }
            SetVarCapacity(key,size,fill=0) {
                this.SetCapacity(key,size)
                DllCall("RtlFillMemory","Ptr",this.GetAddress(key),"Ptr",size,"uchar",fill)
                return this.GetAddress(key)
            }
            CacheImage(image) {
                local
                if (this.imageCache.haskey(image))
                    return 1
                if (image = "") {
                    this.Err("Error, expected resource image path but empty variable was supplied!")
                    return 0
                }
                if (!FileExist(image)) {
                    this.Err("Error finding resource image","'" image "' does not exist!")
                    return 0
                }
                DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", &image, "Ptr*", bm)
                DllCall("gdiplus\GdipGetImageWidth", "Ptr", bm, "Uint*", w)
                DllCall("gdiplus\GdipGetImageHeight", "Ptr", bm, "Uint*", h)
                VarSetCapacity(r,16,0)
                NumPut(w,r,8,"uint")
                NumPut(h,r,12,"uint")
                VarSetCapacity(bmdata, 32, 0)
                DllCall("Gdiplus\GdipBitmapLockBits", "Ptr", bm, "Ptr", &r, "uint", 3, "int", 0x26200A, "Ptr", &bmdata)
                scan := NumGet(bmdata, 16, "Ptr")
                p := DllCall("GlobalAlloc", "uint", 0x40, "ptr", 16+((w*h)*4), "ptr")
                DllCall(this._cacheImage,"Ptr",p,"Ptr",scan,"int",w,"int",h,"uchar",255)
                DllCall("Gdiplus\GdipBitmapUnlockBits", "Ptr", bm, "Ptr", &bmdata)
                DllCall("gdiplus\GdipDisposeImage", "ptr", bm)
                VarSetCapacity(props,64,0)
                NumPut(28,props,0,"uint")
                NumPut(1,props,4,"uint")
                if (this.bits) {
                    NumPut(w,this.tBufferPtr,0,"uint")
                    NumPut(h,this.tBufferPtr,4,"uint")
                    if (v := DllCall(this.vTable(this.renderTarget,4),"ptr",this.renderTarget,"int64",NumGet(this.tBufferPtr,"int64"),"ptr",p,"uint",4 * w,"ptr",&props,"ptr*",bitmap) != 0) {
                        this.Err("Problem creating D2D bitmap for image '" image "'")
                        return 0
                    }
                } else {
                    if (v := DllCall(this.vTable(this.renderTarget,4),"ptr",this.renderTarget,"uint",w,"uint",h,"ptr",p,"uint",4 * w,"ptr",&props,"ptr*",bitmap) != 0) {
                        this.Err("Problem creating D2D bitmap for image '" image "'")
                        return 0
                    }
                }
                return this.imageCache[image] := {p:bitmap,w:w,h:h}
            }
            CacheFont(name,size,bold:=400) {
                if (DllCall(this.vTable(this.wFactory,15),"ptr",this.wFactory,"wstr",name,"ptr",0,"uint",bold,"uint",0,"uint",5,"float",size,"wstr","en-us","ptr*",textFormat) != 0) {
                    this.Err("Unable to create font: " name " (size: " size ", bold: " bold ")","Try a different font or check to see if " name " is a valid font!")
                    return 0
                }
                return this.fonts[name size bold] := textFormat
            }
            __Delete() {
                DllCall("gdiplus\GdiplusShutdown", "Ptr*", this.gdiplusToken)
                DllCall(this.vTable(this.factory,2),"ptr",this.factory)
                DllCall(this.vTable(this.stroke,2),"ptr",this.stroke)
                DllCall(this.vTable(this.strokeRounded,2),"ptr",this.strokeRounded)
                DllCall(this.vTable(this.renderTarget,2),"ptr",this.renderTarget)
                DllCall(this.vTable(this.brush,2),"ptr",this.brush)
                DllCall(this.vTable(this.wfactory,2),"ptr",this.wfactory)
                guiID := this.guiID
                gui %guiID%:destroy
            }
            InitFuncs() {
                this._DrawText := this.vTable(this.renderTarget,27)
                this._BeginDraw := this.vTable(this.renderTarget,48)
                this._Clear := this.vTable(this.renderTarget,47)
                this._DrawImage := this.vTable(this.renderTarget,26)
                this._EndDraw := this.vTable(this.renderTarget,49)
                this._RMatrix := this.vTable(this.renderTarget,30)
                this._DrawEllipse := this.vTable(this.renderTarget,20)
                this._FillEllipse := this.vTable(this.renderTarget,21)
                this._DrawRectangle := this.vTable(this.renderTarget,16)
                this._FillRectangle := this.vTable(this.renderTarget,17)
                this._DrawRoundedRectangle := this.vTable(this.renderTarget,18)
                this._FillRoundedRectangle := this.vTable(this.renderTarget,19)
                this._DrawLine := this.vTable(this.renderTarget,15)
                this._NRSize := this.vTable(this.renderTarget,58)
                this._SetBrush := this.vTable(this.brush,8)
            }
            Mcode(str) {
                local
                s := strsplit(str,"|")
                if (s.length() != 2)
                    return
                if (!DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", 0, "uint*", pp, "ptr", 0, "ptr", 0))
                    return
                p := DllCall("GlobalAlloc", "uint", 0, "ptr", pp, "ptr")
                if (this.bits)
                    DllCall("VirtualProtect", "ptr", p, "ptr", pp, "uint", 0x40, "uint*", op)
                if (DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", p, "uint*", pp, "ptr", 0, "ptr", 0))
                    return p
                DllCall("GlobalFree", "ptr", p)
            }
            Display(state) {
                if (state) {
                    WinHide, % "ahk_id " this.hwnd
                } else {
                    WinShow, % "ahk_id " this.hwnd
                }
            }
        }
        ShinsOverlayClass_OnErase() {
            return 0
        }
;; End Antra's bag of tricks


;------------------------------------------------- HOTKEYS BELOW, just change the bit after " and before : -----------------------------------
; Example, change ^4 in "^4:StartScript" to +4 becomes "+4:StartScript" which is Shift & 4 ..... or change it to F5 becomes F5:StartScript so the keybind is F5

; Honestly just use numbers (1,2,3,4.....) or F keys (F4 to Start...) or Ctrl (^4 = Ctrl 4 to start...) 

; Define hotkeys and their labels in a single place
hotkeyDefinitions := ["F8:StartScript", "F7:ReloadScript", "F6:ExitApplication"]

;------------------------------------------------- HOTKEYS ABOVE, just change the bit after " and before : -----------------------------------

; Initialize hotkeys associative array
hotkeys := {}

; Dynamically create hotkey bindings and populate the hotkeys array
Loop, % hotkeyDefinitions.MaxIndex()
{
    hotkeyDef := hotkeyDefinitions[A_Index]
    StringSplit, hotkeyParts, hotkeyDef, `: ; Split the hotkey definition into parts
    hotkey := hotkeyParts1
    action := hotkeyParts2
    
    ; Create the hotkey binding dynamically
    Hotkey, %hotkey%, %action%

    ; Populate the hotkeys array
    hotkeys[hotkey] := action
}

; Function to translate hotkey symbols to readable names
translateHotkey(hotkey) {
    result := ""
    key := ""
    
    Loop, Parse, hotkey
    {
        if (A_LoopField = "^")
            result .= "Ctrl & "
        else if (A_LoopField = "+")
            result .= "Shift & "
        else if (A_LoopField = "!")
            result .= "Alt & "
        else if (A_LoopField = "#")
            result .= "Win & "
        else
            key .= A_LoopField
    }
    
    result .= key
    return result
}

; Function to generate overlay text based on hotkeys
getOverlayText(status) {
    global hotkeys
    startHotkey := ""
    stopHotkey := ""
    exitHotkey := ""

    for k, v in hotkeys {
        if (v = "StartScript") {
            startHotkey := translateHotkey(k)
        } else if (v = "ReloadScript") {
            stopHotkey := translateHotkey(k)
        } else if (v = "ExitApplication") {
            exitHotkey := translateHotkey(k)
        }
    }

    if (status = 0) {
        return "| Please ensure you are at the launch screen | " startHotkey " to Start | " exitHotkey " to Exit | Thrallway.com"
    } else if (status = 1) {
        return "| You can tab out now | " stopHotkey " to Stop | " exitHotkey " to Exit | Thrallway.com"
    }
}

; Function to generate message box text based on hotkeys
getMsgBoxText() {
    global hotkeys
    startHotkey := ""
    stopHotkey := ""
    exitHotkey := ""

    for k, v in hotkeys {
        if (v = "StartScript") {
            startHotkey := translateHotkey(k)
        } else if (v = "ReloadScript") {
            stopHotkey := translateHotkey(k)
        } else if (v = "ExitApplication") {
            exitHotkey := translateHotkey(k)
        }
    }

    return "BE IN ORBIT BEFORE STARTING THE MACRO `n ......................................... `n `n- Private Match Crucible`n- Game Type: Collision`n- Map: The Burnout `n- Match Score Limit: 25`n`n- Press F8 to start the script when you are at the GREEN LAUNCH BUTTON Screen`n `n ......................................... `n  `nIf you want to change KEYBINDS below, check ~Line 2203 in the code under HOTKEYS section `n  `n " startHotkey "   to Start`n " stopHotkey "   to Reload/Stop script`n " exitHotkey "   to Quit/Exit script `n`n READY? Press Yes then Start the macro with the keybind"
}

; Initial call to show the message box
; ShowInitialMsgBox()

; Function to display the initial message box
ShowInitialMsgBox()
{
    Loop
    {
        msgBoxText := getMsgBoxText()
        MsgBox, 4, Start Script, %msgBoxText%
        IfMsgBox Yes
        {
            ; Exit the loop if Yes is pressed
            Break
        }
        Else
        {
            ; No action
            MsgBox, Please follow the instructions again, and press Yes once ready.
        }
    }
}

;######################

; Create a new Xbox 360 controller
360Controller := new ViGEmXb360()
overlay := new ShinsOverlayClass("ahk_exe destiny2.exe")

; Set a timer to update the overlay
SetTimer, UpdateOverlay, 1000
gosub, UpdateOverlay
return

UpdateOverlay:
    if WinActive("ahk_exe destiny2.exe") {
        WinGetPos, x, y, w, h, ahk_exe destiny2.exe
        if (overlay.beginDraw()) {
            overlayText := getOverlayText(status)
            overlay.drawText(overlayText, 10, 0, 32, 0xFFFFFFFF, "Courier", "olFF000000")
            overlay.endDraw()
        } else {
            overlay := new ShinsOverlayClass("ahk_exe destiny2.exe")
        }
    } else {
        overlay.Clear()
        overlay := ""
    }
return

; Start Script Label
StartScript:
    Status = 1
    360Controller.Buttons.LB.SetState(true)
    Sleep, 100
    360Controller.Buttons.LB.SetState(false)
    Sleep, 100
    360Controller.Buttons.LB.SetState(true)
    Sleep, 100
    360Controller.Buttons.LB.SetState(false)
    Sleep, 100
    360Controller.Buttons.LB.SetState(true)
    Sleep, 100
    360Controller.Buttons.LB.SetState(false)
    Sleep, 100
    Loop {
        ; 
        360Controller.Buttons.Start.SetState(true)
        Sleep, 500
        360Controller.Buttons.Start.SetState(false)
        Sleep, 1000
        360Controller.Buttons.B.SetState(true)
        Sleep, 100
        360Controller.Buttons.B.SetState(false)
        Sleep, 1000
        ; Launch
        360Controller.Axes.LX.SetState(100)
        Sleep, 750
        360Controller.Axes.LX.SetState(50)
        Sleep, 500
        360Controller.Axes.LY.SetState(0)
        Sleep, 500
        360Controller.Axes.LY.SetState(50)
        Sleep, 100
        360Controller.Buttons.A.SetState(true)
        Sleep, 100
        360Controller.Buttons.A.SetState(false)
        Sleep, 58000
        ; Forward
        360Controller.Buttons.LS.SetState(true)
        360Controller.Axes.LY.SetState(100)
        Sleep, 5000
        360Controller.Axes.LY.SetState(50)
        Sleep, 100
        360Controller.Buttons.LS.SetState(false)
        PreciseSleep(400)
        ; Turn Right
        360Controller.Axes.RX.SetState(90)
        PreciseSleep(1300)
        360Controller.Axes.RX.SetState(50)
        PreciseSleep(200)
        ; Forward
        360Controller.Buttons.LS.SetState(true)
        360Controller.Axes.LY.SetState(100)
        PreciseSleep(2000)
        360Controller.Axes.LY.SetState(50)
        Sleep, 100
        360Controller.Buttons.LS.SetState(false)
		Sleep, 50
		; Super Casts (this is super jank and there's probably a better way to do this but idk how)
		360Controller.Buttons.RB.SetState(true)
		360Controller.Buttons.LB.SetState(true)
		Sleep, 50
		360Controller.Buttons.RB.SetState(false)
		360Controller.Buttons.LB.SetState(false)
		Sleep, 12000
		360Controller.Buttons.RB.SetState(true)
		360Controller.Buttons.LB.SetState(true)
		Sleep, 50
		360Controller.Buttons.RB.SetState(false)
		360Controller.Buttons.LB.SetState(false)
		Sleep, 12000
		360Controller.Buttons.RB.SetState(true)
		360Controller.Buttons.LB.SetState(true)
		Sleep, 50
		360Controller.Buttons.RB.SetState(false)
		360Controller.Buttons.LB.SetState(false)
		Sleep, 12000
		360Controller.Buttons.RB.SetState(true)
		360Controller.Buttons.LB.SetState(true)
		Sleep, 50
		360Controller.Buttons.RB.SetState(false)
		360Controller.Buttons.LB.SetState(false)
		Sleep, 12000
		360Controller.Buttons.RB.SetState(true)
		360Controller.Buttons.LB.SetState(true)
		Sleep, 50
		360Controller.Buttons.RB.SetState(false)
		360Controller.Buttons.LB.SetState(false)
		Sleep, 50
        ; Idle
        360Controller.Axes.LY.SetState(100)
        Sleep, 200
        360Controller.Axes.LY.SetState(50)
        Sleep, 100
        360Controller.Axes.LY.SetState(0)
        Sleep, 200
        360Controller.Axes.LY.SetState(50)
        Sleep, 11700
        ; Back to Orbit
        360Controller.Buttons.Y.SetState(true)
        Sleep, 7000
        360Controller.Buttons.Y.SetState(false)
        Sleep, 6000
    }
Return

; Reload Script Label
ReloadScript:
    Reload
Return

; Exit Script Label
ExitApplication:
    ExitApp
Return
