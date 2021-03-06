require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { build :user }
  let(:post) { create :post }
  let(:comment) { build :comment }
  let(:user2) { create :user }
  let(:comment2) { create :comment }

  describe 'Validations' do
    context 'when content is missing' do
      it 'is invalid' do
        comment.comment_content = nil
        comment.valid?
        expect(comment.errors[:comment_content]).to include("can't be blank")
      end
    end
    
    context 'when content is present' do
      it 'is valid' do
        comment.valid?
        expect(comment.errors[:comment_content]).to be_blank
      end
    end

    context 'when content has more than 200 characters' do
      it 'is invalid' do
        comment.comment_content = 'a' * 201
        comment.valid?
        expect(comment.errors[:comment_content].to_s)
        .to include("maximum is 200")
      end
    end
    
    context 'when content has <= 200 characters' do
      it 'is valid' do
        comment.comment_content = 'a' * 200
        comment.valid?
        expect(comment.errors[:comment_content]).to be_blank
      end
    end
  end

  describe 'Association' do
    context 'when user likes a comment' do
      it 'returns numbers of likes associated with a comment' do
        user2.liked(comment2)
        expect(comment2.likes_count).to eq 1
      end
    end
    
    context 'when post is deleted' do      
      it 'is expected to destroy dependent comments' do
        post.comments << comment
        post.destroy
        expect(Comment.count).to be 0
      end
    end
  end
end
