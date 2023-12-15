-module(split_sum).
-export([start/0, split_sum/1, test_cases/1]).

% Main entry point, exposed externally.
split_sum(Nums) ->
     split_sum(Nums, 0, 0, 1, length(Nums)).

% Empty array, or single element array.
split_sum(Nums, _TotalLeft, _TotalRight, _Left, _Right) when length(Nums) < 2 ->
    {[],[]};

% When the indexes meet in the middle, return the answer.
split_sum(Nums, TotalLeft, TotalRight, Left, Right) when Right =:= Left ->
    Temp = lists:nth(Left, Nums),
    PossibleLeft  = TotalLeft  + Temp,
    PossibleRight = TotalRight + Temp,
    % Check middle in left or right group.
    if PossibleLeft =:= TotalRight -> lists:split(Left, Nums);
       PossibleRight =:= TotalLeft -> lists:split(Left - 1, Nums);
       true -> {[],[]}
    end;

% Add to the side with a smaller total.
split_sum(Nums, TotalLeft, TotalRight, Left, Right) ->
    if TotalLeft =< TotalRight ->
           split_sum(Nums, TotalLeft  + lists:nth(Left, Nums), TotalRight, Left + 1, Right);
       true -> 
           split_sum(Nums, TotalLeft, TotalRight + lists:nth(Right, Nums), Left, Right - 1)
    end.

% Test casses
test_cases(ToScreen) ->
    lists:foreach(
        fun(Case) ->
            case ToScreen of
                true  -> io:format("Erlang: ~w -> ~w~n", [Case, split_sum(Case)]);
                false -> split_sum(Case)
            end
        end, 
        [ [],
          [100],
          [99, 99],
          [98, 1, 99],
          [99, 1, 98],
          [1, 2, 3, 0],
          [1, 2, 3, 5],
          [1, 2, 2, 1, 0],
          [10, 11, 12, 16, 17],
          [1, 1, 1, 1, 1, 1, 6],
          [6, 1, 1, 1, 1, 1, 1]
        ]
    ).

% Repeating the test cases.
test_cases(_ToScreen, Count) when Count < 1 -> ok;
test_cases(ToScreen, Count) ->
    test_cases(ToScreen),
    test_cases(ToScreen, Count - 1).


start() ->
    test_cases(true),
    Timer = erlang:monotonic_time(millisecond),
    test_cases(false, 1000000),
    TimeElapsed = erlang:monotonic_time(millisecond) - Timer,
    io:format("Erlang: ~w seconds~n", [TimeElapsed/1000]).

