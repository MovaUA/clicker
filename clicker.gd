class_name Clicker extends Control

@export var company_data: CompanyData = CompanyData.new()
@onready var company_capital: Label = %CompanyCapital
@onready var games_made_per_click: Label = %GamesMadePerClick
@onready var games_made_and_sold: Label = %GamesMadeAndSold
@onready var developers_hired_count: Label = %DevelopersHiredCount
@onready var make_and_sell_game_button: Button = %MakeAndSellGameButton
@onready var increase_factor_timer: Timer = %IncreaseFactorTimer
@onready var hire_new_developer_button: Button = %HireNewDeveloperButton

func _ready() -> void:
	make_and_sell_game_button.pressed.connect(make_and_sell_game)
	hire_new_developer_button.pressed.connect(hire_new_developer)
	increase_factor_timer.wait_time = company_data.games_made_per_click_increase_interval_seconds
	increase_factor_timer.timeout.connect(increase_factor)
	_display_company_data()

func make_and_sell_game() -> void:
	company_data.sold_games_count += company_data.games_per_click_count
	company_data.company_capital_usd += company_data.games_per_click_count * company_data.game_price_usd
	_display_company_data()

func hire_new_developer() -> void:
	company_data.game_delevelopers_count += 1
	company_data.company_capital_usd -= company_data.game_deleveloper_price_usd
	var tween := create_tween()

	_display_company_data()

func increase_factor() -> void:
	if company_data.game_delevelopers_count == 0:
		return
	company_data.games_per_click_count *= company_data.game_delevelopers_count * company_data.games_made_per_click_increase_factor_per_deleloper
	_display_company_data()

var games_made_per_click_increase_interval_seconds

func _display_company_data() -> void:
	company_capital.text = str(company_data.company_capital_usd)
	games_made_per_click.text = "%d" % company_data.games_per_click_count
	games_made_and_sold.text = "%d" % company_data.sold_games_count
	developers_hired_count.text = "%d" % company_data.game_delevelopers_count
	hire_new_developer_button.disabled = company_data.company_capital_usd < company_data.game_deleveloper_price_usd
