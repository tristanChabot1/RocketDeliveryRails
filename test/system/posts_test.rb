require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "should create post" do
    visit posts_url
    click_on "New post"

    fill_in "Email", with: @post.email
    fill_in "Encrypted password", with: @post.encrypted_password
    fill_in "Name", with: @post.name
    fill_in "Remember created at", with: @post.remember_created_at
    fill_in "Reset password sent at", with: @post.reset_password_sent_at
    fill_in "Reset password token", with: @post.reset_password_token
    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Back"
  end

  test "should update Post" do
    visit post_url(@post)
    click_on "Edit this post", match: :first

    fill_in "Email", with: @post.email
    fill_in "Encrypted password", with: @post.encrypted_password
    fill_in "Name", with: @post.name
    fill_in "Remember created at", with: @post.remember_created_at
    fill_in "Reset password sent at", with: @post.reset_password_sent_at
    fill_in "Reset password token", with: @post.reset_password_token
    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Back"
  end

  test "should destroy Post" do
    visit post_url(@post)
    click_on "Destroy this post", match: :first

    assert_text "Post was successfully destroyed"
  end
end
