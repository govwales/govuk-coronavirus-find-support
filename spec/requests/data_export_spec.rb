RSpec.describe "data-export" do
  let(:start_date) { "2020-04-10" }
  let(:end_date) { "2020-04-15" }

  before do
    FormResponse.create(
      form_response: {
       able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
       get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
      },
      created_at: "2020-04-10 10:00:00"
     )
    FormResponse.create(
      form_response: {
        able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
        get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
      },
      created_at: "2020-04-10 10:00:00"
    )
    FormResponse.create(
      form_response: {
        able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
        get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
      },
      created_at: "2020-04-11 10:00:00"
    )
    FormResponse.create(
      form_response: {
        able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_other.label"),
        get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
      },
      created_at: "2020-04-11 10:00:00"
    )
  end

  describe "GET /able-to-leave" do
    let(:expected_lines) do
      [
        %{question,answer,date,count},
        %{"Are you able to leave your home for food, medicine, or health reasons?",Yes,2020-04-10,2},
        %{"Are you able to leave your home for food, medicine, or health reasons?",Yes,2020-04-11,1},
        %{"Are you able to leave your home for food, medicine, or health reasons?",No,2020-04-11,1},
        %{Are you able to get food?,Yes,2020-04-10,1},
        %{Are you able to get food?,No,2020-04-10,1},
        %{Are you able to get food?,Yes,2020-04-11,1},
        %{Are you able to get food?,No,2020-04-11,1},
      ]
    end

    it "shows all expected responses in CSV format" do
      get data_export_path, params: { start_date: start_date, end_date: end_date }, headers: { "HTTP_ACCEPT" => "text/csv" }

      expected_lines.each do |line|
        expect(response.body).to have_content(line)
      end
    end
  end
end
