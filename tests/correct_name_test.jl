#=
correct_name_test:
- Julia version: 
- Author: Анастасия
- Date: 2019-11-30
=#
include("../src/available_functions.jl")
using .available_functions
using Test
using SQLite
using DataFrames
@testset "correct_name_test" begin
db_t = SQLite.DB("dosk")
SQLite.execute!(db_t, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pen"
amount1 = 2
price1 = 15
name2 = "pencil"
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(db_t, query)
@test correct_name(db_t, name1) == 0
@test correct_name(db_t, name2) == -1
end