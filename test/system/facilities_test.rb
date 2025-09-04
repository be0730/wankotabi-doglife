require "application_system_test_case"

class FacilitiesTest < ApplicationSystemTestCase
  setup do
    skip "WIP: 調整中"
    @facility = facilities(:one)
  end

  test "visiting the index" do
    visit facilities_url
    assert_selector "h1", text: "Facilities"
  end

  test "should create facility" do
    skip "WIP"
    visit facilities_url
    click_on "New facility"

    fill_in "Title", with: @facility.title
    click_on "Create Facility"

    assert_text "Facility was successfully created"
    click_on "Back"
  end

  test "should update Facility" do
    skip "WIP"
    visit facility_url(@facility)
    click_on "Edit this facility", match: :first

    fill_in "Title", with: @facility.title
    click_on "Update Facility"

    assert_text "Facility was successfully updated"
    click_on "Back"
  end

  test "should destroy Facility" do
    skip "WIP"
    visit facility_url(@facility)
    click_on "Destroy this facility", match: :first

    assert_text "Facility was successfully destroyed"
  end
end
