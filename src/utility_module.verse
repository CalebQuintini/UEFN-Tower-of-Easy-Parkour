# This file defines the utility module that contains a number of extension functions, constants and functions for performing various tasks.

using { /Fortnite.com/Devices }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/SceneGraph }

Utility<public> := module:

    # Extension functions for passing arguments with events.
    # Code taken from: https://dev.epicgames.com/community/snippets/d8k/fortnite-wrapping-subscribe-to-pass-additional-data-to-listeners.
    # Changed agent to ?agent so could be used with trigger devices
    (Listenable : listenable(?agent)).SubscribeAgent<public>(OutputFunc : tuple(?agent, t)->void, ExtraData : t where t:type) : cancelable =
        Wrapper := wrapper_agent(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
        Listenable.Subscribe(Wrapper.InputFunc)
        
    wrapper_agent(t : type) := class():
        ExtraData : t
        OutputFunc : tuple(?agent, t) -> void
        InputFunc(Agent : ?agent):void = OutputFunc(Agent, ExtraData)

    (Listenable : listenable(player)).SubscribePlayer<public>(OutputFunc : tuple(player, t)->void, ExtraData : t where t:type) : cancelable =
        Wrapper := wrapper_player(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
        Listenable.Subscribe(Wrapper.InputFunc)
    wrapper_player(t : type) := class():
        ExtraData : t
        OutputFunc : tuple(player, t) -> void
        InputFunc(Agent : player):void = OutputFunc(Agent, ExtraData)

    (Listenable : listenable(widget_message)).SubscribeWidgetMessage<public>(OutputFunc : tuple(widget_message, t)->void, ExtraData : t where t:type) : cancelable =
        Wrapper := wrapper_widget_message(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
        Listenable.Subscribe(Wrapper.InputFunc)
        
    wrapper_widget_message(t : type) := class():
        ExtraData : t
        OutputFunc : tuple(widget_message, t) -> void
        InputFunc(Message : widget_message):void = OutputFunc(Message, ExtraData)

    (Listenable : listenable(agent)).SubscribeAgent2<public>(OutputFunc2 : tuple(agent, t)->void, ExtraData : t where t:type) : cancelable =
        Wrapper := wrapper_agent2(t){ExtraData := ExtraData, OutputFunc2 := OutputFunc2}
        Listenable.Subscribe(Wrapper.InputFunc2)
    wrapper_agent2(t : type) := class():
        ExtraData : t
        OutputFunc2 : tuple(agent, t) -> void
        InputFunc2(Agent : agent):void = OutputFunc2(Agent, ExtraData)

    (Listenable : listenable(entity)).SubscribeEntity<public>(OutputFunc3 : tuple(entity, t)->void, ExtraData : t where t:type) : cancelable =
        Wrapper := wrapper_entity(t){ExtraData := ExtraData, OutputFunc3 := OutputFunc3}
        Listenable.Subscribe(Wrapper.InputFunc3)
    wrapper_entity(t : type) := class():
        ExtraData : t
        OutputFunc3 : tuple(entity, t) -> void
        InputFunc3(Entity : entity):void = OutputFunc3(Entity, ExtraData)
    
    # Extension function for removing a key from a map.
    (Input:[t]t2 where t:subtype(comparable), t2:type).RemoveKey<public>(KeyToRemove:t)<decides><transacts>:[t]t2=
        var Output:[t]t2 = map{}
        for (Key -> Value : Input, Key <> KeyToRemove):
            set Output = ConcatenateMaps(Output, map{Key => Value})
        Output

    # Extension function for removing all matching elements from an array.
    (Input:[]t where t:type).RemoveAll<public>(Element:t, Compare(A:t, B:t)<decides><transacts>:void)<decides><transacts>:[]t=
        var Output:[]t = array{}
        for(InputElement : Input):
            if (not Compare[InputElement, Element]):
                set Output += array{InputElement}

        Output

    # Functions for localizing text.
    PlainText<public><localizes>(Text:string):message = "{Text}"

    CountText<public><localizes>(Count:int):message = "{Count}"

    CountTextFloat<public><localizes>(Count:float):message = "Current Amount: {Count}"

    StringToMessage<public><localizes>(value:string) : message = "{value}"

    LevelText<public><localizes>(Level:int, MaxLevel:int):message = "Level {Level} / {MaxLevel}"

    ProgressText<public><localizes>(Level:int, MaxLevel:int):message = "{Level}/{MaxLevel}"

    NewLevelText<public><localizes>(Level:int):message = "{Level}"

    StatText<public><localizes>(Level:string):message = "+ {Level}"

    SpeedMultiplier<public><localizes>(Multiplier:float):message = "{Multiplier}x"

    PlayerText<public><localizes>(PrefixText:string, Player:player, SuffixText:string):message = "{PrefixText}{Player}{SuffixText}"

    PlayerNameText<public><localizes>(InPlayer:player) : message = "{InPlayer}"

    PlayerNameTextArea1Stage2<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 1 Stage 2"
    PlayerNameTextArea1Stage4<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 1 Stage 4"
    PlayerNameTextArea2Stage2<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 2 Stage 2"
    PlayerNameTextArea2Stage4<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 2 Stage 4"
    PlayerNameTextArea3Stage2<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 3 Stage 2"
    PlayerNameTextArea3Stage4<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 3 Stage 4"
    PlayerNameTextArea4Stage2<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 4 Stage 2"
    PlayerNameTextArea4Stage4<public><localizes>(InPlayer:player) : message = "{InPlayer} is requesting help in Area 4 Stage 4"

    # Function for creating a string from a positive number by padding it with a character. 
    PadNumber<public>(PositiveNumber:int, PadToLength:int, Character:char)<transacts>:[]char=
        var Result : []char = "{PositiveNumber}"

        if (Result.Length < PadToLength):
            PadCount := PadToLength - Result.Length
            for(Count := 1..PadCount):
                set Result = array{Character} + Result

        Result

    # Function for rounding float to a certain positive number of decimals.
    # Code taken from: https://forums.unrealengine.com/t/how-to-round-float-to-x-decimal-places/821189/4
    (Input:float).ToString<public>(Decimals:int)<transacts>:string=
        Multiplier := Pow(10.0, Decimals * 1.0)
        if:
            RoundedValue := (Round[Input * Multiplier] * 1.0) / Multiplier
            BeforeDecimal := Floor[RoundedValue]
            AfterDecimal := Abs(Round[(RoundedValue - BeforeDecimal * 1.0) * Multiplier])
            var AfterDecimalString:string = ToString(AfterDecimal)
            
            for(X := 0..Decimals-AfterDecimalString.Length-1):
                set AfterDecimalString = "0" + AfterDecimalString
        then:
            "{BeforeDecimal}.{AfterDecimalString}"
        else:
            ToString(Input)

    # Function for parsing an integer from a string.
    ParseInt<public>(String : string)<decides><transacts>:int=
        String.Length > 0

        var Result : int = 0
        var Digit : int = 1
        for(Index := 0..String.Length-1):
            CharIndex := String.Length-1 - Index
            Char := String[CharIndex]
            case(Char):
                '-' => 
                    set Result *= -1
                '0' =>
                    set Digit *= 10
                '1' =>
                    set Result += 1 * Digit
                    set Digit *= 10
                '2' =>
                    set Result += 2 * Digit
                    set Digit *= 10
                '3' =>
                    set Result += 3 * Digit
                    set Digit *= 10
                '4' =>
                    set Result += 4 * Digit
                    set Digit *= 10
                '5' =>
                    set Result += 5 * Digit
                    set Digit *= 10
                '6' =>
                    set Result += 6 * Digit
                    set Digit *= 10
                '7' =>
                    set Result += 7 * Digit
                    set Digit *= 10
                '8' =>
                    set Result += 8 * Digit
                    set Digit *= 10
                '9' =>
                    set Result += 9 * Digit
                    set Digit *= 10
                '.' =>
                ',' =>
                _ => false?
        Result

    ToTruncatedString<public>(Number:float, Decimals:int):[]char=
        var Str:[]char = ToString(Number)
        if:
            DotIndex := Str.Find['.']
            StopIndex := if (Decimals > 0) then Min(DotIndex+Decimals+1,Str.Length) else DotIndex
            if (StrT := Str.Slice[0, StopIndex]) {
                set Str = StrT
            }
        return Str

    FormatCountdownTime<public>(TimeLeft:float):string =
        if (TotalSeconds := Int[TimeLeft]):
            if (Minutes := Quotient[TotalSeconds, 60]):
                if (Seconds := Mod[TotalSeconds, 60]):
                    MinutesStr := if (Minutes < 10) { "0{Minutes}" } else { "{Minutes}" }
                    SecondsStr := if (Seconds < 10) { "0{Seconds}" } else { "{Seconds}" }
                    return "{MinutesStr}:{SecondsStr}"
        return "00:00" # fallback if any conversion fails

    FormatFloatFixed(Value:float, DecimalPlaces:int):string =
        Multiplier := Pow(10.0, DecimalPlaces * 1.0)
        if (RoundedValue := Round[Value * Multiplier]):
            RoundedFloat := RoundedValue * 1.0 / Multiplier
            FloatStr := ToString(RoundedFloat) # e.g. "1.2", "1"
            # Find the decimal point in a failure context
            if (DotIndex := FloatStr.Find["."]):
                Decimals := FloatStr.Length - DotIndex - 1
                # Always slice the string to the correct number of decimals
                if (SlicedStr := FloatStr.Slice[0, DotIndex + DecimalPlaces + 1]):
                    SlicedStr
                else:
                    FloatStr # Fallback if Slice fails
            else:
                # No decimal point found, pad decimals
                FloatStr + "." + Repeat("0", DecimalPlaces)
        else:
            "0.00"
    
    # Helper to repeat a character n times
    Repeat(Str:string, Times:int):string =
            var Out : string = ""
            for (I := 0..Times - 1):
                set Out = Out + Str
            Out
    
    AbbreviateNumber<public>(value:float) : string =
        if (value >= 1.0e63):
            return ToTruncatedString(value / 1.0e63, 2) + "V"
        else if (value >= 1.0e60):
            return ToTruncatedString(value / 1.0e60, 2) + "Nd"
        else if (value >= 1.0e57):
            return ToTruncatedString(value / 1.0e57, 2) + "Od"
        else if (value >= 1.0e54):
            return ToTruncatedString(value / 1.0e54, 2) + "Spd"
        else if (value >= 1.0e51):
            return ToTruncatedString(value / 1.0e51, 2) + "Sxd"
        else if (value >= 1.0e48):
            return ToTruncatedString(value / 1.0e48, 2) + "Qid"
        else if (value >= 1.0e45):
            return ToTruncatedString(value / 1.0e45, 2) + "Qad"
        else if (value >= 1.0e42):
            return ToTruncatedString(value / 1.0e42, 2) + "Td"
        else if (value >= 1.0e39):
            return ToTruncatedString(value / 1.0e39, 2) + "Dd"
        else if (value >= 1.0e36):
            return ToTruncatedString(value / 1.0e36, 2) + "Ud"
        else if (value >= 1.0e33):
            return ToTruncatedString(value / 1.0e33, 2) + "Dc"
        else if (value >= 1.0e30):
            return ToTruncatedString(value / 1.0e30, 2) + "No"
        else if (value >= 1.0e27):
            return ToTruncatedString(value / 1.0e27, 2) + "Oct"
        else if (value >= 1.0e24):
            return ToTruncatedString(value / 1.0e24, 2) + "Sp"
        else if (value >= 1.0e21):
            return ToTruncatedString(value / 1.0e21, 2) + "Sx"
        else if (value >= 1.0e18):
            return ToTruncatedString(value / 1.0e18, 2) + "Qi"
        else if (value >= 1.0e15):
            return ToTruncatedString(value / 1.0e15, 2) + "Q"
        else if (value >= 1.0e12):
            return ToTruncatedString(value / 1.0e12, 2) + "T"
        else if (value >= 1.0e9):
            return ToTruncatedString(value / 1.0e9, 2) + "B"
        else if (value >= 1.0e6):
            return ToTruncatedString(value / 1.0e6, 2) + "M"
        else if (value >= 1.0e3):
            return ToTruncatedString(value / 1.0e3, 2) + "K"
        else:
            return ToTruncatedString(value, 0)

    AbbreviateNumberNoDecimals<public>(value:float) : string =
        if (value >= 1.0e36):
            return ToTruncatedStringNoDecimals(value / 1.0e36, 0) + "Ud"
        else if (value >= 1.0e33):
            return ToTruncatedStringNoDecimals(value / 1.0e33, 0) + "Dc"
        else if (value >= 1.0e30):
            return ToTruncatedStringNoDecimals(value / 1.0e30, 0) + "No"
        else if (value >= 1.0e27):
            return ToTruncatedStringNoDecimals(value / 1.0e27, 0) + "Oc"
        else if (value >= 1.0e24):
            return ToTruncatedStringNoDecimals(value / 1.0e24, 0) + "Sp"
        else if (value >= 1.0e21):
            return ToTruncatedStringNoDecimals(value / 1.0e21, 0) + "Sx"
        else if (value >= 1.0e18):
            return ToTruncatedStringNoDecimals(value / 1.0e18, 0) + "Qi"
        else if (value >= 1.0e15):
            return ToTruncatedStringNoDecimals(value / 1.0e15, 0) + "Q"
        else if (value >= 1.0e12):
            return ToTruncatedStringNoDecimals(value / 1.0e12, 0) + "T"
        else if (value >= 1.0e9):
            return ToTruncatedStringNoDecimals(value / 1.0e9, 0) + "B"
        else if (value >= 1.0e6):
            return ToTruncatedStringNoDecimals(value / 1.0e6, 0) + "M"
        else if (value >= 1.0e3):
            return ToTruncatedStringNoDecimals(value / 1.0e3, 0) + "K"
        else:
            return ToTruncatedStringNoDecimals(value, 0)
 
    ToTruncatedStringNoDecimals<public>(Number:float, Decimals:int):[]char=
        var Str:[]char = ToString(Number)
        if:
            DotIndex := Str.Find['.']
            if (Decimals = 0):
                if (StrT := Str.Slice[0, DotIndex]) {
                    set Str = StrT
                }
            else:
                StopIndex := Min(DotIndex+Decimals+1,Str.Length)
                if (StrT := Str.Slice[0, StopIndex]) {
                    set Str = StrT
                }
        return Str

    ClaimStatus<public> := enum:
        Claimed
        Unclaimed

    conveyor_belt_levels<public>:= class:
        @editable
        PropsTrigger<public>:trigger_device = trigger_device{}
        @editable
        PropsBuyButton<public>:creative_prop = creative_prop{}
        @editable
        PropText<public>:creative_prop = creative_prop{}
        @editable
        BuyableProp<public>:[]creative_prop=array{}

