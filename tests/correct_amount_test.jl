#=
correct_amount_test:
- Julia version: 
- Author: Анастасия
- Date: 2019-11-30
=#
include("../src/available_functions.jl")
using .available_functions
using Test
using SQLite
using DataFrames
@testset "correct_amount_test" begin
db_t = SQLite.DB("dosk")
SQLite.execute!(db_t, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pen"
amount1 = 2
price1 = 15
amount2 = 4
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(db_t, query)
@test correct_amount(db_t, name1, amount1) == 0
@test correct_amount(db_t, name1, amount2) == -1
end