module Api
  module V1
    class LoansController < ApplicationController
      before_action :authenticate_user
      before_action :authorize_as_admin, only: [:destroy]

      def index
        loans = Loan.order('created_at DESC')
        render json: {
          status: 'SUCCESS', message: 'All loans', data: loans
        }, status: :ok
      end

      def show
        loan = Loan.find(params[:id])
        render json: {
          status: 'SUCCESS', message: 'Loaded loan', data: loan
        }, status: :ok
      end

      def create
        loan = Loan.new(loan_params)
        not_be_blank(loan)
        loan.quota_value = (loan.total_loans / loan.quantity_quotas).round(2)
        if loan.save
          render json: {
            status: 'SUCCESS', message: 'Saved loan', data: loan
          }, status: :ok
        else
          render json: {
            status: 'ERROR', message: 'Loan not saved', data: loan.errors
          }, status: :unprocessable_entity
        end
      end

      def destroy
        loan = Loan.find(params[:id])
        loan.destroy
        render json: {
          status: 'SUCCESS', message: 'Deleted Loan', data: loan
        }, status: :ok
      end

      private

      def loan_params
        params.permit(:name, :cpf, :total_loans, :quantity_quotas)
      end

      def not_be_blank(loan)
        if loan.total_loans.nil?
          loan.total_loans = 0
        elsif loan.quantity_quotas.nil?
          loan.quantity_quotas = 0
        end
      end
    end
  end
end
