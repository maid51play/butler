import React from 'react';
import PropTypes from 'prop-types';
import MaidForm from './maidForm';

const maidEditComponent = ({ token, maid }) => (
  <div>
    <h2>Edit maid</h2>
    <MaidForm token={token} maid={maid} action={`/admin/maids/${maid.id}`} method="post" />
    <a className="btn btn-danger btn-xs pull-right" data-confirm="Are you sure?" data-csrf={token} data-method="delete" data-to={`/admin/maids/${maid.id}`} href={`/admin/maids/${maid.id}`} rel="nofollow">Delete</a>
  </div>
);

maidEditComponent.propTypes = {
  token: PropTypes.string.isRequired,
  maid: PropTypes.shape({
    name: PropTypes.string,
  }),
};

maidEditComponent.defaultProps = {
  maid: {},
};

export default maidEditComponent;
