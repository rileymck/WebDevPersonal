class Student < ApplicationRecord
    has_one_attached :profile_picture
    validates :first_name, :last_name, :school_email, :major, :minor, :graduation_date, presence: true
    validates :school_email, uniqueness: true
    validates :school_email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    validate :custom_email_validation
    validate :acceptable_image

    VALID_MAJORS = ["Computer Engineering BS", "Computer Information Systems BS", "Computer Science BS", "Cybersecurity Major", "Data Science and Machine Learning Major"]

    validates :major, inclusion: {in: VALID_MAJORS, message: "%{value} is not a valid major"}

    private

    def custom_email_validation
        # Add any additional custom email validations here
    end
    
      

      def acceptable_image
        if profile_picture.attached?
          puts "Profile picture is attached and validation is running"
          
          unless profile_picture.byte_size <= 1.megabyte
            errors.add(:profile_picture, "is too big")
          end
      
          acceptable_types = ["image/jpeg", "image/png"]
          unless acceptable_types.include?(profile_picture.content_type)
            errors.add(:profile_picture, "must be a JPEG or PNG")
          end
        else
          puts "No profile picture attached, skipping validation"
        end
      end
      
end
