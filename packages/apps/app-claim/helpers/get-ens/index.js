export default ({ email = '' }) => email.slice(0, email.indexOf('@')).replace('.', '_') + '.linkdrop.xyz'
