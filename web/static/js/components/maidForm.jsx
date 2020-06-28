import React from 'react';
import PropTypes from 'prop-types';

const maidFormComponent = ({
  token,
  action,
  method,
  maid,
}) => (
  <div>
    <form acceptCharset="UTF-8" action={action} method={method}>
      {maid.id && <input name="_method" type="hidden" value="put" />}
      <input name="_csrf_token" type="hidden" value={token} />
      <div className="form-group">
        <label className="control-label" htmlFor="maid_name">
          Name:
          <input className="form-control" id="maid_name" name="maid[name]" defaultValue={maid && maid.name} />
        </label>
      </div>

      <div className="form-group">
        <button className="btn btn-primary" type="submit">Submit</button>
      </div>
    </form>
    <a href="/maids">Back</a>
  </div>
);

maidFormComponent.propTypes = {
  token: PropTypes.string.isRequired,
  action: PropTypes.string.isRequired,
  method: PropTypes.string.isRequired,
  maid: PropTypes.shape({
    name: PropTypes.string,
  }),
};

maidFormComponent.defaultProps = {
  maid: {},
};

export default maidFormComponent;
