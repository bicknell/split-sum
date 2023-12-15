-module(split_sum).
-export([start/0, split_sum/1, test_cases/1]).

% Main entry point
split_sum(Nums) ->
    {TotalLeft, TotalRight, Left, Right} = {0, 0, 1, length(Nums)},
    split_sum_loop(Nums, TotalLeft, TotalRight, Left, Right).

% Empty array, or single element array.
split_sum_loop(Nums, _TotalLeft, _TotalRight, _Left, _Right) when length(Nums) < 2 ->
    {[],[]};

% Sum until the indexes meet in the middle.
split_sum_loop(Nums, TotalLeft, TotalRight, Left, Right) when Right =:= Left ->
    PossibleLeft = TotalLeft + lists:nth(Left, Nums),
    PossibleRight = TotalRight + lists:nth(Left, Nums),
    % Check middle in left or right group.
    if PossibleLeft =:= TotalRight -> lists:split(Left, Nums);
        PossibleRight =:= TotalLeft -> lists:split(Left - 1, Nums);
        true -> {[],[]}
    end;

% Do the summation
split_sum_loop(Nums, TotalLeft, TotalRight, Left, Right) ->
    if TotalLeft =< TotalRight ->
            {NewTotalLeft, NewLeft} = update_left(Nums, Left, TotalLeft),
            split_sum_loop(Nums, NewTotalLeft, TotalRight, NewLeft, Right);
        true -> 
            {NewTotalRight, NewRight} = update_right(Nums, Right, TotalRight),
            split_sum_loop(Nums, TotalLeft, NewTotalRight, Left, NewRight)
    end.

update_left(Nums, Left, TotalLeft)    -> {TotalLeft  + lists:nth(Left, Nums),  Left + 1 }.
update_right(Nums, Right, TotalRight) -> {TotalRight + lists:nth(Right, Nums), Right - 1}.

% Test casses
test_cases(ToScreen) ->
    lists:foreach(fun(Case) ->
        case ToScreen of
          true -> io:format("Erlang: ~w -> ~w~n", [Case, split_sum(Case)]);
          false -> split_sum(Case)
        end
      end, [ [],
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
           ]).

start() ->
    test_cases(true),
    Timer = erlang:monotonic_time(millisecond),
    lists:foreach(
      fun(_) ->
        split_sum:test_cases(false)
      end,
      lists:duplicate(1000000, [])
    ),
    TimeElapsed = erlang:monotonic_time(millisecond) - Timer,
    io:format("Erlang: ~w seconds~n", [TimeElapsed/1000]).

